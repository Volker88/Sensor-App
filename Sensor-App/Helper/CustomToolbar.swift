//
//  CustomToolbar.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.08.20.
//

import SwiftUI

struct CustomToolbar: ToolbarContent {
    var toolBarFunctionClosure: (ToolBarButtonType) -> Void

    var body: some ToolbarContent {

        ToolbarItem(placement: .bottomBar) { Spacer() }

        ToolbarItem(placement: .bottomBar) {
            Button(action: { buttonTapped(type: .play) }) {
                Image(systemName: "play.circle")
                    .accessibility(label: Text("Play", comment: "CustomToolbar - Play Button"))
            }
        }

        ToolbarItem(placement: .bottomBar) { Spacer() }

        ToolbarItem(placement: .bottomBar) {
            Button(action: { buttonTapped(type: .pause) }) {
                Image(systemName: "pause.circle")
                    .accessibility(label: Text("Pause", comment: "CustomToolbar - Pause Button"))
            }

        }

        ToolbarItem(placement: .bottomBar) { Spacer() }

        ToolbarItem(placement: .bottomBar) {
            Button(action: { buttonTapped(type: .delete) }) {
                Image(systemName: "trash.circle")
                    .accessibility(label: Text("Delete", comment: "CustomToolbar - Delete Button"))
            }
        }

        ToolbarItem(placement: .bottomBar) { Spacer() }
    }

    func buttonTapped(type: ToolBarButtonType) {
        toolBarFunctionClosure(type)
    }
}
