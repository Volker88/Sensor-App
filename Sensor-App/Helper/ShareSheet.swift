//
//  ShareSheet.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 10.08.22.
//
//

import SwiftUI

struct ShareSheet: View {

    let url: URL

    // MARK: - Body
    var body: some View {
        ShareLink(item: url) {
            Label {
                Text("Export", comment: "Export button to export data as csv file")
            } icon: {
                Image(systemName: "square.and.arrow.up")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ShareSheet(url: URL(string: "https://www.apple.com")!)  // swiftlint:disable:this force_unwrapping
}
