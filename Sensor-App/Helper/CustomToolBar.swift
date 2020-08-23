//
//  CustomToolBar.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - ToolBarView
struct CustomToolBar: ViewModifier {
    
    // MARK: - @State / @ObservedObject / @Binding
    
    
    // MARK: - Define Constants / Variables
    var toolBarFunctionClosure: (ToolBarButtonType) -> Void
    
    
    // MARK: - Methods
    func buttonTapped(type: ToolBarButtonType) {
        toolBarFunctionClosure(type)
    }
    
    func body(content: Content) -> some View {
        
        return content
            .toolbar{
                ToolbarItemGroup(placement: .bottomBar) {     
                    Spacer()
                    Button(action: { self.buttonTapped(type: .delete) } ) {
                        Image(systemName: "trash.circle")
                            .toolBarButtonModifier(accessibility: "Delete Button")
                            .accessibility(label: Text("Delete", comment: "ToolBarView - Delete Button"))
                    }
                    Spacer()
                    Button(action: { self.buttonTapped(type: .pause) } ) {
                        Image(systemName: "pause.circle")
                            .toolBarButtonModifier(accessibility: "Pause Button")
                            .accessibility(label: Text("Pause", comment: "ToolBarView - Pause Button"))
                    }
                    Spacer()
                    Button(action: { self.buttonTapped(type: .play) } ) {
                        Image(systemName: "play.circle")
                            .accessibility(label: Text("Play", comment: "ToolBarView - Play Button"))
                    }
                    .toolBarButtonModifier(accessibility: "Start Button")
                    Spacer()
                }
            }
    }
}


// MARK: - Extension View
extension View {
    
    // MARK: - Define Function
    ///
    /// customToolBar
    ///
    ///  Custom Tool Bar
    ///
    /// - Parameter toolBarFunctionClosure: (ToolBarButtonType) -> Void
    /// - Returns: Void
    ///
    func customToolBar(toolBarFunctionClosure: @escaping (ToolBarButtonType) -> Void) -> some View {
        return  modifier(CustomToolBar(toolBarFunctionClosure: toolBarFunctionClosure))
    }
}
