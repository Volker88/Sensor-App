//
//  NotificationMessageView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 28.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct NotificationMessageView: View {
    @Binding var notificationText: String

    var body: some View {
        Text(notificationText)
            .padding()
            .frame(minWidth: 250)
            .background(Color.gray)
            .cornerRadius(20)
    }
}

struct NotificationMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationMessageView(notificationText: .constant("Saved Successfully"))
            .previewLayout(.sizeThatFits)
    }
}
