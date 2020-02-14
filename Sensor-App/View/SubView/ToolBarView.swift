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
    
    // MARK: - @State / @Binding Variables
    @Binding var toolBarButtonType: ToolBarButtonType
    
    
    // MARK: - Define Constants / Variables
    var toolBarFunctionClosure: () -> Void
    
    
    // MARK: - Methods
    func buttonTapped(type: ToolBarButtonType) {
        switch type {
            case .play: toolBarButtonType = .play
            case .pause: toolBarButtonType = .pause
            case .delete: toolBarButtonType = .delete
            case .settings: toolBarButtonType = .settings
        }
        toolBarFunctionClosure()
    }

    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
        return GeometryReader { g in
            HStack{
                Spacer()
                Button(action: { self.buttonTapped(type: .play)} ) {
                    Image(systemName: "play.circle")
                        .font(.largeTitle)
                }
                .accessibility(identifier: "Start Button")
                Spacer()
                Button(action: { self.buttonTapped(type: .pause)} ) {
                    Image(systemName: "pause.circle")
                        .font(.largeTitle)
                }
                .accessibility(identifier: "Pause Button")
                Spacer()
                Button(action: { self.buttonTapped(type: .delete)} ) {
                    Image(systemName: "trash.circle")
                        .font(.largeTitle)
                }
                .accessibility(identifier: "Delete Button")
                Spacer()
                Button(action: { self.buttonTapped(type: .settings)} ) {
                    Image(systemName: "gear")
                        .font(.largeTitle)
                }
                .accessibility(identifier: "Settings Button")
                Spacer()
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
            ToolBarView(toolBarButtonType: .constant(.play), toolBarFunctionClosure: { })
                .colorScheme(scheme)
                .previewLayout(.fixed(width: 400, height: 50))
        }
    }
}
