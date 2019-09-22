//
//  LocationToolBarView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - ToolBarView
struct LocationToolBarView: View {
    
    // MARK: - @State / @Binding Variables
    @State private var showSettings = false
    @Binding var notificationMessage: String
    @Binding var showNotification: Bool
    @Binding var notificationDuration: Double
    
    
    // MARK: - Methods
    func playButtonTapped() {
        CoreLocationAPI.shared.startUpdatingGPS()
        NotificationAPI.shared.toggleNotification(type: .played, duration: self.notificationDuration) { (message, show) in
            self.notificationMessage = message
            self.showNotification = show
        }
    }
    
    func pauseButtonTapped() {
        CoreLocationAPI.shared.stopUpdatingGPS()
        NotificationAPI.shared.toggleNotification(type: .paused, duration: self.notificationDuration) { (message, show) in
            self.notificationMessage = message
            self.showNotification = show
        }
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
        return GeometryReader { g in
            HStack{
                Spacer()
                Button(action: self.playButtonTapped) {
                    Image(systemName: "play.circle")
                        .font(.largeTitle)
                }
                Spacer()
                Button(action: self.pauseButtonTapped) {
                    Image(systemName: "pause.circle")
                        .font(.largeTitle)
                }
                Spacer()
                Button(action: {
                    self.showSettings.toggle()
                }) {
                    Image(systemName: "gear")
                        .font(.largeTitle)
                }
                Spacer()
            }
            .frame(width: g.size.width + g.safeAreaInsets.leading + g.safeAreaInsets.trailing, height: 50, alignment: .center)
            .foregroundColor(Color("ToolbarTextColor"))
            .background(Color("ToolbarBackgroundColor"))
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}


// MARK: - Preview
struct LocationToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        LocationToolBarView(notificationMessage: .constant("Paused"), showNotification: .constant(true), notificationDuration: .constant(2.0))
            .previewLayout(.sizeThatFits)
    }
}
