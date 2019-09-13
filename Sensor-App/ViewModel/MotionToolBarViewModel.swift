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
struct MotionToolBarViewModel: View {
    
    // MARK: - Methods
    func playButtonTapped() {
        CoreMotionAPI.shared.motionStartMethod()
    }
    
    func pauseButtonTapped() {
        CoreMotionAPI.shared.motionStopMethod()
    }
    
    func deleteButtonTapped() {
        CoreMotionAPI.shared.clearMotionArray {  }
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        GeometryReader { geometry in
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
                Button(action: {
                    self.deleteButtonTapped()
                }) {
                    Image(systemName: "trash.circle")
                    .font(.largeTitle)
                }
                Spacer()
            }
            .frame(width: geometry.size.width + geometry.safeAreaInsets.leading + geometry.safeAreaInsets.trailing, height: 50, alignment: .center)
            .foregroundColor(Color("ToolbarTextColor"))
            .background(Color("ToolbarBackgroundColor"))
        }
    }
}


// MARK: - Preview
#if DEBUG
struct MotionToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        MotionToolBarViewModel()
            .previewLayout(.sizeThatFits)
    }
}
#endif
