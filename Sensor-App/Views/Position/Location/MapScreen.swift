//
//  MapScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.07.22.
//

import MapKit
import Sensor_App_Framework
import SwiftUI

struct MapScreen: View {

    @Environment(\.colorScheme) private var colorScheme

    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var mapStyleConfig = MapStyleConfig()
    @State private var showMapStylePicker = false

    @Namespace private var mapScope

    // MARK: - Body
    var body: some View {
        Map(position: $cameraPosition, scope: mapScope) {
            UserAnnotation()
        }
        .mapStyle(mapStyleConfig.mapStyle)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()

                VStack(spacing: 5) {
                    MapPitchToggle(scope: mapScope)
                        .mapControlVisibility(.visible)

                    Button {
                        showMapStylePicker.toggle()
                    } label: {
                        Image(systemName: "map.fill")
                            .imageScale(.large)
                            .dynamicTypeSize(.medium)
                    }
                    .padding(10)
                    .background(.ultraThickMaterial)
                    .clipShape(.circle)

                    MapUserLocationButton(scope: mapScope)
                }
                .foregroundStyle(colorScheme == .light ? .black : .white)
                .padding(5)
                .buttonBorderShape(.circle)
            }
            .padding()
        }
        .mapScope(mapScope)
        .sheet(isPresented: $showMapStylePicker) {
            MapStyleView(mapStyleConfig: $mapStyleConfig)
                .presentationDetents([.height(350), .medium, .large])
        }
    }
}

// MARK: - Preview
#Preview("MapView - English", traits: .navEmbedded) {
    MapScreen()
}

#Preview("MapView - German", traits: .navEmbedded) {
    MapScreen()
        .previewLocalization(.german)
}
