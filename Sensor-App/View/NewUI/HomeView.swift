//
//  HomeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct / Class Definition
struct HomeView: View {
    
    // MARK: - Initialize Classes
    
    // MARK: - Environment Object
    
    // MARK: - @State / @ObservedObject / @Binding
    @State var sideBarOpen: Bool = false
    
    
    // MARK: - Define Constants / Variables
    
    // MARK: - Initializer
    
    // MARK: - Methods
    
    
    // MARK: - Content
    var sideBarButton: some View {
        Button(action: {
            sideBarOpen.toggle()
        }) {
            Image(systemName: "sidebar.left")
        }
    }
    
    var content: some View {
        VStack {
            
            VStack {
                Text("Welcome to the", comment: "ContentView - Welcome Label")
                Text("Sensor-App", comment: "ContentView - Sensor-App")
            }
            .contentViewTitleModifier()
            Spacer()
        }
        .frame(height: 100, alignment: .center)
        .offset(x: 5)
    }
    
    
    // MARK: - Body
    @ViewBuilder
    var body: some View {
        
        // MARK: - Return View
        GeometryReader { geo in
            ScrollView {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    content
                        .navigationBarItems(leading: sideBarButton)
                        .navigationBarTitle("\(NSLocalizedString("Home", comment: "HomeView - NavigationBar Title"))", displayMode: .inline)
                } else {
                    content
                        .navigationBarTitle("\(NSLocalizedString("Home", comment: "HomeView - NavigationBar Title"))", displayMode: .inline)
                }
            }
            
            
            // MARK: - SidebarMenu
            SidebarMenu(sidebarOpen: $sideBarOpen)
        }
    }
}


// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            HomeView()
                .colorScheme(scheme)
        }
    }
}

