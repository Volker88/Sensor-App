//
//  ToolBarView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - ToolBarView
struct ToolBarView: View {
    
    // MARK: - @State / @ObservedObject / @Binding
    
    
    // MARK: - Define Constants / Variables
    var toolBarFunctionClosure: (ToolBarButtonType) -> Void
    
    
    // MARK: - Methods
    func buttonTapped(type: ToolBarButtonType) {
        toolBarFunctionClosure(type)
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return GeometryReader { g in
            HStack {
                Group {
                    Spacer()
                    Button(action: { self.buttonTapped(type: .play)} ) {
                        Image(systemName: "play.circle")
                            .toolBarButtonModifier(accessibility: "Start Button")
                            .accessibility(label: Text("Play", comment: "ToolBarView - Play Button"))
                    }
                    Spacer()
                    Button(action: { self.buttonTapped(type: .pause)} ) {
                        Image(systemName: "pause.circle")
                            .toolBarButtonModifier(accessibility: "Pause Button")
                            .accessibility(label: Text("Pause", comment: "ToolBarView - Pause Button"))
                    }
                    Spacer()
                }
                Group {
                    Button(action: { self.buttonTapped(type: .delete)} ) {
                        Image(systemName: "trash.circle")
                            .toolBarButtonModifier(accessibility: "Delete Button")
                            .accessibility(label: Text("Delete", comment: "ToolBarView - Delete Button"))
                    }
                    Spacer()
                    Button(action: { self.buttonTapped(type: .share)} ) {
                        Image(systemName: "square.and.arrow.up")
                            .toolBarButtonModifier(accessibility: "Share Button")
                            .accessibility(label: Text("Share", comment: "ToolBarView - Share Button"))
                    }
                    Spacer()
                    Button(action: { self.buttonTapped(type: .settings)} ) {
                        Image(systemName: "gear")
                            .toolBarButtonModifier(accessibility: "Settings Button")
                            .accessibility(label: Text("Settings", comment: "ToolBarView - Settings Button"))
                    }
                    Spacer()
                }
            }
            .frame(width: g.size.width + g.safeAreaInsets.leading + g.safeAreaInsets.trailing, height: 50, alignment: .center)
            .foregroundColor(Color("ToolbarTextColor"))
            .background(Color("ToolbarBackgroundColor"))
        }
    }
}


// MARK: - Preview
struct LocationToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            ToolBarView(toolBarFunctionClosure: { type in })
                .colorScheme(scheme)
                .previewLayout(.fixed(width: 400, height: 50))
        }
    }
}
