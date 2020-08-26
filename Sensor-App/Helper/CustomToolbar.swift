//
//  CustomToolbar.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - ToolBarView
struct CustomToolbar: ToolbarContent {
    
    // MARK: - @State / @ObservedObject / @Binding
    
    
    // MARK: - Define Constants / Variables
    var toolBarFunctionClosure: (ToolBarButtonType) -> Void
    
    
    // MARK: - Methods
    func buttonTapped(type: ToolBarButtonType) {
        toolBarFunctionClosure(type)
    }
    
    
    // MARK: - Body
    var body: some ToolbarContent {
        
        ToolbarItem(placement: .bottomBar) { Spacer() }
        
        ToolbarItem(placement: .bottomBar) {
            Button(action: { buttonTapped(type: .play) } ) {
                Image(systemName: "play.circle")
                    .toolBarButtonModifier(accessibility: "Start Button")
                    .accessibility(label: Text("Play", comment: "ToolBarView - Play Button"))
            }
        }
        
        ToolbarItem(placement: .bottomBar) { Spacer() }
        
        ToolbarItem(placement: .bottomBar) {
            Button(action: { buttonTapped(type: .pause) } ) {
                Image(systemName: "pause.circle")
                    .toolBarButtonModifier(accessibility: "Pause Button")
                    .accessibility(label: Text("Pause", comment: "ToolBarView - Pause Button"))
            }
        }
        
        ToolbarItem(placement: .bottomBar) { Spacer() }
        
        ToolbarItem(placement: .bottomBar) {
            Button(action: { buttonTapped(type: .delete) } ) {
                Image(systemName: "trash.circle")
                    .toolBarButtonModifier(accessibility: "Delete Button")
                    .accessibility(label: Text("Delete", comment: "ToolBarView - Delete Button"))
            }
        }
        
        ToolbarItem(placement: .bottomBar) { Spacer() }
    }
}
