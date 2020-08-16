//
//  ContentView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct ContentView: View {
    
    // MARK: - Initialize Classes
    let settings = SettingsAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @State var showSettings = false
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - onAppear / onDisappear
    
    
    // MARK: - Body
    var body: some View {
        
        // MARK: - Return View
        return Text("Hello")
            .toolbar{
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: { } ) {
                            Image(systemName: "play.circle")
                                .toolBarButtonModifier(accessibility: "Start Button")
                                .accessibility(label: Text("Play", comment: "ToolBarView - Play Button"))
                        }
                        
                        Button(action: { } ) {
                            Image(systemName: "pause.circle")
                                .toolBarButtonModifier(accessibility: "Pause Button")
                                .accessibility(label: Text("Pause", comment: "ToolBarView - Pause Button"))
                        }
                        
                        Button(action: { } ) {
                            Image(systemName: "trash.circle")
                                .toolBarButtonModifier(accessibility: "Delete Button")
                                .accessibility(label: Text("Delete", comment: "ToolBarView - Delete Button"))
                        }
                        
                        Button(action: { } ) {
                            Image(systemName: "square.and.arrow.up")
                                .toolBarButtonModifier(accessibility: "Share Button")
                                .accessibility(label: Text("Share", comment: "ToolBarView - Share Button"))
                        }
                    }
                }
            }
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            ContentView()
                .colorScheme(scheme)
        }
    }
}
