//
//  ContentView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import SwiftUI

struct ContentView: View {

    @Environment(MotionManager.self) private var motionManager
    @Environment(AppState.self) private var appState

    @State private var showSidebar: NavigationSplitViewVisibility = .all

    // MARK: - Body
    var body: some View {
        NavigationSplitView(columnVisibility: $showSidebar) {
            Sidebar()
        } detail: {
            NavigationStack(path: Bindable(appState).path) {
                DetailColumn()
            }
        }
        .onChange(of: appState.selectedScreen) {
            motionManager.stopMotionUpdates()
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .previewNavigationStackWrapper()
}
