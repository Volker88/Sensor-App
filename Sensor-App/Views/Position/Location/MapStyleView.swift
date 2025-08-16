//
//  MapStyleView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 15.08.25.
//

import MapKit
import SwiftUI

struct MapStyleView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var mapStyleConfig: MapStyleConfig

    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Picker("Base Style", selection: $mapStyleConfig.baseStyle) {
                    ForEach(MapStyleConfig.BaseMapStyle.allCases, id: \.self) { type in
                        Text(type.label)
                    }
                }

                Picker("Elevation", selection: $mapStyleConfig.elevation) {
                    Text("Flat").tag(MapStyleConfig.MapElevation.flat)
                    Text("Realistic").tag(MapStyleConfig.MapElevation.realistic)
                }

                if mapStyleConfig.baseStyle != .imagery {
                    Toggle("Show Traffic", isOn: $mapStyleConfig.showTraffic)
                }

                Button {
                    dismiss()
                } label: {
                    Text("OK")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
            }

            //            VStack(alignment: .leading) {
            //                LabeledContent("Base Style") {
            //                    Picker("Base Style", selection: $mapStyleConfig.baseStyle) {
            //                        ForEach(MapStyleConfig.BaseMapStyle.allCases, id: \.self) { type in
            //                            Text(type.label)
            //                        }
            //                    }
            //                }
            //
            //                LabeledContent("Elevation") {
            //                    Picker("Elevation", selection: $mapStyleConfig.elevation) {
            //                        Text("Flat").tag(MapStyleConfig.MapElevation.flat)
            //                        Text("Realistic").tag(MapStyleConfig.MapElevation.realistic)
            //                    }
            //                }
            //
            //                if mapStyleConfig.baseStyle != .imagery {
            //                    Toggle("Show Traffic", isOn: $mapStyleConfig.showTraffic)
            //                }
            //
            //                Button {
            //                    dismiss()
            //                } label: {
            //                    Text("OK")
            //                        .frame(maxWidth: .infinity)
            //                }
            //                .buttonStyle(.glassProminent)
            //                .padding()
            //            }
            //            .padding()
            .navigationTitle("Map Style")
            .navigationSubtitle("Customize the map appearance")
            .navigationBarTitleDisplayMode(.inline)

            //            Spacer()
        }
    }
}

// MARK: - Preview
#Preview("MapStypeView - English") {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            MapStyleView(mapStyleConfig: .constant(MapStyleConfig.init()))
                .presentationDetents([.height(350), .medium, .large])
        }
}

#Preview("MapStypeView - German") {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            MapStyleView(mapStyleConfig: .constant(MapStyleConfig.init()))
                .presentationDetents([.height(350), .medium, .large])
                .previewLocalization(.german)
        }
}
