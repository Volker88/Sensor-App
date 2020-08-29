//
//  SidebarMenu.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct / Class Definition
struct SidebarMenu: View {
    
    // MARK: - @State / @ObservedObject / @Binding
    @Binding var sidebarOpen: Bool
    
    // MARK: - Body
    var body: some View {
        SideMenuView(width: 250,
                     isOpen: sidebarOpen,
                     menuClose: { sidebarOpen = false })
            .animation(.easeInOut)
//            .gesture(
//                DragGesture(minimumDistance: 50)
//                    .onChanged { value in
//                        let direction = SwipeDirectionAPI.getSwipeDirection(value: value)
//                        if direction == .right {
//                            #if os(iOS)
//                            if UIDevice.current.userInterfaceIdiom == .phone {
//                                sidebarOpen = true
//                            }
//                            #endif
//                        }
//                    })
    }
}


// MARK: - Preview
struct SidebarMenu_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            SidebarMenu(sidebarOpen: .constant(true))
                .colorScheme(scheme)
        }
    }
}
