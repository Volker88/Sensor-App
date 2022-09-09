//
//  ContentView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var motionVM: CoreMotionViewModel
    @EnvironmentObject private var appState: AppState
    @State private var showSidebar: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $showSidebar) {
            Sidebar()
        } detail: {
            NavigationStack(path: $appState.path) {
                DetailColumn()
            }
        }
        .onChange(of: appState.selectedScreen) { _ in
//            appState.path.removeAll()
            motionVM.stop()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
