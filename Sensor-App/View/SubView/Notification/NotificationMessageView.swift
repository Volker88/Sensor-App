//
//  NotificationMessageView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 28.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - NotificationViewModel
struct NotificationMessageView: View {
    
    // MARK: - @State / @Binding Variables
    @Binding var notificationText: String
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
        return Text(notificationText)
            .padding()
            .foregroundColor(Color("NotificationTextGroundColor"))
            .frame(minWidth: 250)
            //.frame(width: UIScreen.main.bounds.width - 10, height: 50)
            .background(Color("NotificationBackGroundColor"))
            .cornerRadius(20)
    }
}


// MARK: - Preview
struct NotificationMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationMessageView(notificationText: .constant("Saved Successfully"))
            .previewLayout(.sizeThatFits)
    }
}

