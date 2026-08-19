//
//  DiagnosticsScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.07.26.
//

import Sensor_App_Framework
import SwiftUI

struct DiagnosticsScreen: View {

    @Environment(MetricKitManager.self) private var metricKit

    var body: some View {
        Form {
            performanceSection
            diagnosticsSection
        }
        .navigationTitle("Diagnostics")
    }
}

// MARK: - Performance section

private struct PerformanceSection: View {

    let report: MetricKitManager.MetricReportSummary

    var body: some View {
        Section("Performance") {
            LabeledContent("Report Period") {
                Text(
                    "\(report.timeRange.start.formatted(.dateTime.month().day())) – \(report.timeRange.end.formatted(.dateTime.month().day()))"
                )
                .foregroundStyle(.secondary)
            }
            if let cpu = report.cpuTime {
                LabeledContent("CPU Time", value: cpu.formatted(.measurement(width: .abbreviated)))
            }
            if let gpu = report.gpuTime {
                LabeledContent("GPU Time", value: gpu.formatted(.measurement(width: .abbreviated)))
            }
            if let memory = report.peakMemory {
                LabeledContent("Peak Memory", value: memory.formatted(.measurement(width: .abbreviated)))
            }
            if let suspended = report.suspendedMemoryAverage {
                LabeledContent("Suspended Memory (avg)", value: suspended.formatted(.measurement(width: .abbreviated)))
            }
            if let launch = report.launchTimeAverage {
                LabeledContent("Launch Time (avg)", value: launch.formatted(.measurement(width: .abbreviated)))
            }
            if let hang = report.hangTimeAverage {
                LabeledContent("Hang Duration (avg)", value: hang.formatted(.measurement(width: .abbreviated)))
            }
        }
    }
}

// MARK: - Diagnostics section

private struct DiagnosticsSection: View {

    let diagnostics: [MetricKitManager.DiagnosticEvent]

    var body: some View {
        Section("Diagnostics (\(diagnostics.count))") {
            ForEach(diagnostics) { event in
                DiagnosticEventRow(event: event)
            }
        }
    }
}

// MARK: - Diagnostic event row
private struct DiagnosticEventRow: View {

    let event: MetricKitManager.DiagnosticEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Label(event.type.rawValue, systemImage: iconName)
                    .font(.headline)
                Spacer()
                Text(event.receivedAt, format: .dateTime.month().day().hour().minute())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(event.detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("v\(event.appVersion)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 2)
    }

    private var iconName: String {
        switch event.type {
            case .crash: "xmark.octagon"
            case .hang: "hourglass"
            case .cpuException: "cpu"
            case .diskWriteException: "externaldrive"
            case .appLaunch: "bolt"
            case .memoryException: "memorychip"
        }
    }
}

// MARK: - DiagnosticsScreen body helpers
extension DiagnosticsScreen {

    @ViewBuilder
    fileprivate var performanceSection: some View {
        if let report = metricKit.latestReport {
            PerformanceSection(report: report)
        } else {
            Section("Performance") {
                ContentUnavailableView(
                    "No Performance Data",
                    systemImage: "chart.bar.xaxis",
                    description: Text("Performance metrics are delivered once per day from real device usage.")
                )
            }
        }
    }

    @ViewBuilder
    fileprivate var diagnosticsSection: some View {
        if metricKit.diagnostics.isEmpty {
            Section("Diagnostics") {
                ContentUnavailableView(
                    "No Diagnostics",
                    systemImage: "checkmark.shield",
                    description: Text("Crash, hang, and exception reports appear here when detected.")
                )
            }
        } else {
            DiagnosticsSection(diagnostics: metricKit.diagnostics)
        }
    }
}

// MARK: - Preview
#Preview("DiagnosticsScreen", traits: .navEmbedded) {
    DiagnosticsScreen()
}
