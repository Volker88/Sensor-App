//
//  MotionToolBarView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - ToolBarView
struct MotionToolBarView: View {
    
    // MARK: - @State / @Binding / @ObservedObject Variables
    @State private var showSettings = false
    @Binding var notificationMessage: String
    @Binding var showNotification: Bool
    @Binding var notificationDuration: Double
    @ObservedObject var motionVM: CoreMotionViewModel
    
    
    // MARK: - Methods
    func playButtonTapped() {
        CoreMotionAPI.shared.motionUpdateStart()
        NotificationAPI.shared.toggleNotification(type: .played, duration: nil) { (message, show) in
            self.notificationMessage = message
            self.showNotification = show
        }
    }
    
    func pauseButtonTapped() {
        CoreMotionAPI.shared.motionUpdateStop()
        NotificationAPI.shared.toggleNotification(type: .paused, duration: nil) { (message, show) in
            self.notificationMessage = message
            self.showNotification = show
        }
    }
    
    func deleteButtonTapped() {
        self.motionVM.coreMotionArray.removeAll()
        self.motionVM.altitudeArray.removeAll()
        NotificationAPI.shared.toggleNotification(type: .deleted, duration: nil) { (message, show) in
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
                Button(action: self.deleteButtonTapped) {
                    Image(systemName: "trash.circle")
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
struct MotionToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        MotionToolBarView(notificationMessage: .constant("Paused"), showNotification: .constant(true), notificationDuration: .constant(2.0), motionVM: CoreMotionViewModel())
            .previewLayout(.sizeThatFits)
    }
}
