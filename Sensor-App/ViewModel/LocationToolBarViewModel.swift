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
struct LocationToolBarViewModel: View {
    
    // MARK: - Methods
    func playButtonTapped() {
        CoreLocationAPI.shared.startGPS()
    }
    
    func pauseButtonTapped() {
        CoreLocationAPI.shared.stopGPS()
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        GeometryReader { g in
            HStack{
                Spacer()
                Button(action: {
                    self.playButtonTapped()
                }) {
                    Image(systemName: "play.circle")
                        .font(.largeTitle)
                }
                Spacer()
                Button(action: {
                    self.pauseButtonTapped()
                }) {
                    Image(systemName: "pause.circle")
                        .font(.largeTitle)
                }
                Spacer()
                
            }
            .frame(width: g.size.width + g.safeAreaInsets.leading + g.safeAreaInsets.trailing, height: 50, alignment: .center)
            .foregroundColor(Color("ToolbarTextColor"))
            .background(Color("ToolbarBackgroundColor"))
        }
    }
}


// MARK: - Preview
#if DEBUG
struct LocationToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        LocationToolBarViewModel()
            .previewLayout(.sizeThatFits)
    }
}
#endif
