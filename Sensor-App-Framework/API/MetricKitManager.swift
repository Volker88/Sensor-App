//
//  MetricKitManager.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 16.07.26.
//

#if os(iOS)
    import MetricKit
    import OSLog
    import Observation

    @Observable
    public final class MetricKitManager {

        // MARK: - Public types
        public struct MetricReportSummary {
            public let timeRange: DateInterval
            public var cpuTime: Measurement<UnitDuration>?
            public var gpuTime: Measurement<UnitDuration>?
            public var peakMemory: Measurement<UnitInformationStorage>?
            public var suspendedMemoryAverage: Measurement<UnitInformationStorage>?
            public var hangTimeHistogram: Histogram<UnitDuration>?
            public var launchTimeHistogram: Histogram<UnitDuration>?

            public var hangTimeAverage: Measurement<UnitDuration>? {
                hangTimeHistogram.flatMap { weightedAverage($0) }
            }

            public var launchTimeAverage: Measurement<UnitDuration>? {
                launchTimeHistogram.flatMap { weightedAverage($0) }
            }

            private func weightedAverage(_ histogram: Histogram<UnitDuration>) -> Measurement<UnitDuration>? {
                var totalCount = 0
                var weightedSum = 0.0
                for bucket in histogram.buckets {
                    let mid =
                        (bucket.lowerBound.converted(to: .milliseconds).value
                            + bucket.upperBound.converted(to: .milliseconds).value) / 2
                    weightedSum += mid * Double(bucket.count)
                    totalCount += bucket.count
                }
                guard totalCount > 0 else { return nil }
                return Measurement(value: weightedSum / Double(totalCount), unit: .milliseconds)
            }
        }

        public struct DiagnosticEvent: Identifiable {
            public let id = UUID()
            public let receivedAt: Date
            public let appVersion: String
            public let detail: String
            public let type: DiagnosticType

            public enum DiagnosticType: String {
                case crash = "Crash"
                case hang = "Hang"
                case cpuException = "CPU Exception"
                case diskWriteException = "Disk Write Exception"
                case appLaunch = "App Launch"
                case memoryException = "Memory Exception"
            }
        }

        // MARK: - Observable properties
        public var latestReport: MetricReportSummary?
        public var diagnostics: [DiagnosticEvent] = []

        // MARK: - Private
        private let manager = MetricManager()
        private let maxDiagnostics = 50

        // MARK: - Init
        public init() {
            Task { for await report in manager.metricReports { process(report) } }
            Task { for await report in manager.diagnosticReports { process(report) } }
        }

        // MARK: - Metric report processing
        private func process(_ report: MetricReport) {
            Logger.metricKit.info("Received MetricKit daily report")

            #if DEBUG
                writePayload(report, prefix: "metric-report")
            #endif

            var summary = MetricReportSummary(timeRange: report.timeRange)
            for entry in report.intervalEntries {
                for result in entry.values {
                    switch result {
                        case .cpuTime(let metric):
                            summary.cpuTime = metric.value
                        case .gpuTime(let metric):
                            summary.gpuTime = metric.value
                        case .peakMemory(let metric):
                            summary.peakMemory = metric.value
                        case .suspendedMemory(let metric):
                            summary.suspendedMemoryAverage = metric.value.average
                        case .hangTime(let metric):
                            summary.hangTimeHistogram = metric.histogram
                        case .timeToFirstDraw(let metric):
                            summary.launchTimeHistogram = metric.histogram
                        default:
                            break
                    }
                }
            }
            latestReport = summary
        }

        // MARK: - Diagnostic report processing
        private func process(_ report: DiagnosticReport) {
            let appVersion = report.environment.applicationVersion
            let receivedAt = Date()
            let detail: String
            let type: DiagnosticEvent.DiagnosticType

            switch report.result {
                case .crash(let diagnostic):
                    type = .crash
                    if let reason = diagnostic.terminationReason {
                        detail = reason.rawValue
                    } else {
                        detail = "Unknown termination reason"
                    }
                case .hang(let diagnostic):
                    type = .hang
                    detail = "Duration: \(diagnostic.hangDuration.formatted(.measurement(width: .abbreviated)))"
                case .cpuException(let diagnostic):
                    type = .cpuException
                    detail = "CPU time: \(diagnostic.totalCPUTime.formatted(.measurement(width: .abbreviated)))"
                case .diskWriteException(let diagnostic):
                    type = .diskWriteException
                    detail = "Written: \(diagnostic.totalBytesWritten.formatted(.measurement(width: .abbreviated)))"
                case .appLaunch(let diagnostic):
                    type = .appLaunch
                    detail = "Duration: \(diagnostic.launchDuration.formatted(.measurement(width: .abbreviated)))"
                case .memoryException:
                    type = .memoryException
                    detail = "Memory limit exceeded"
                @unknown default:
                    return
            }

            #if DEBUG
                writePayload(report, prefix: "diagnostic-\(type.rawValue.lowercased().replacing(" ", with: "-"))")
            #endif

            let event = DiagnosticEvent(receivedAt: receivedAt, appVersion: appVersion, detail: detail, type: type)
            Logger.metricKit.info("Received diagnostic: \(event.type.rawValue)")
            diagnostics.insert(event, at: 0)
            if diagnostics.count > maxDiagnostics {
                diagnostics.removeLast()
            }
        }

        // MARK: - Debug payload persistence
        #if DEBUG
            private func writePayload<T: Encodable>(_ payload: T, prefix: String) {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                guard let data = try? encoder.encode(payload) else {
                    Logger.metricKit.error("Failed to encode MetricKit payload for '\(prefix)'")
                    return
                }
                let timestamp = Int(Date().timeIntervalSince1970)
                let filename = "\(prefix)-\(timestamp).json"
                let url = URL.documentsDirectory.appending(path: filename)
                do {
                    try data.write(to: url, options: .atomic)
                    Logger.metricKit.info("Wrote MetricKit payload → \(url.lastPathComponent)")
                } catch {
                    Logger.metricKit.error("Failed to write '\(filename)': \(error)")
                }
            }
        #endif
    }
#endif
