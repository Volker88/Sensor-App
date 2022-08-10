//
//  ShareSheet.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 10.08.22.
//
// swiftlint:disable line_length

import SwiftUI

struct ShareSheet: View {
    let url: URL

    var body: some View {
        ShareLink(item: url) {
            Label(NSLocalizedString("Export", comment: "AccelerationView - Export List"), systemImage: "square.and.arrow.up")
        }
    }
}

struct ShareSheet_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheet(url: URL(string: "https://www.apple.com")!)
    }
}
