//
//  SignalBoardScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.10.26.
//

import KickstartSignal
import SwiftUI

struct SignalBoardScreen: View {

    @Binding var showSignalBoard: Bool

    private var apiKey: String {
        #if DEBUG
            "preview"
        #else
            Bundle.main.object(forInfoDictionaryKey: "KICKSTART_EXCHANGE_API_KEY") as? String ?? "preview"
        #endif
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            SignalBoardView(apiKey: apiKey)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close", systemImage: "xmark") {
                            showSignalBoard = false
                        }
                    }
                }
        }
    }
}

// MARK: - Preview
#Preview("SignalBoardScreen - English", traits: .navEmbedded) {
    SignalBoardScreen(showSignalBoard: .constant(true))
}

#Preview("SignalBoardScreen - German", traits: .navEmbedded) {
    SignalBoardScreen(showSignalBoard: .constant(true))
        .previewLocalization(.german)
}
