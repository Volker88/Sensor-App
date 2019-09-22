//
//  ButtonView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 10.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - ButtonView
struct ButtonView: View {
    
    // MARK: - @State / @Binding Variables
    @State var type: ParameterType?
    @State var text: String
    @ObservedObject var motionVM = CoreMotionViewModel()
    @ObservedObject var locationVM = CoreLocationViewModel()
    
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Define Constants / Variables
        let value : Double
        let unit : String
        
        // MARK: - type-Switch
        switch type {
        case .longitude:
            value = (locationVM.coreLocationArray.last?.longitude ?? 0.0).rounded(toPlaces: 10)
            unit = " ±\(String(format: "%.2f", self.locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0))m"
        case .latitude:
            value = (locationVM.coreLocationArray.last?.latitude ?? 0.0).rounded(toPlaces: 10)
            unit = " ±\(String(format: "%.2f", self.locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0))m"
        case .altitude:
            value = (locationVM.coreLocationArray.last?.altitude ?? 0.0).rounded(toPlaces: 10)
            unit = " ±\(String(format: "%.2f", self.locationVM.coreLocationArray.last?.verticalAccuracy ?? 0.0))m"
        case .speed:
            value = CalculationAPI.shared.calculateSpeed(ms: locationVM.coreLocationArray.last?.speed ?? 0.0, to: "\(SettingsAPI.shared.fetchSpeedSetting())").rounded(toPlaces: 2)
            unit = " \(SettingsAPI.shared.fetchSpeedSetting())"
        case .course:
            value = (locationVM.coreLocationArray.last?.course ?? 0.0).rounded(toPlaces: 5)
            unit = "°"
        case .accelerationXAxis:
            value = (motionVM.coreMotionArray.last?.accelerationXAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " m/s^2"
        case .accelerationYAxis:
            value = (motionVM.coreMotionArray.last?.accelerationYAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " m/s^2"
        case .accelerationZAxis:
            value = (motionVM.coreMotionArray.last?.accelerationZAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " m/s^2"
        case .gravityXAxis:
            value = (motionVM.coreMotionArray.last?.gravityXAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " g (9,81 m/s^2)"
        case .gravityYAxis:
            value = (motionVM.coreMotionArray.last?.gravityYAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " g (9,81 m/s^2)"
        case .gravityZAxis:
            value = (motionVM.coreMotionArray.last?.gravityZAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " g (9,81 m/s^2)"
        case .gyroXAxis:
            value = (motionVM.coreMotionArray.last?.gyroXAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " rad/s"
        case .gyroYAxis:
            value = (motionVM.coreMotionArray.last?.gyroYAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " rad/s"
        case .gyroZAxis:
            value = (motionVM.coreMotionArray.last?.gyroZAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " rad/s"
        case .magnetometerXAxis:
            value = (motionVM.coreMotionArray.last?.magnetometerXAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " µT"
        case .magnetometerYAxis:
            value = (motionVM.coreMotionArray.last?.magnetometerYAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " µT"
        case .magnetometerZAxis:
            value = (motionVM.coreMotionArray.last?.magnetometerZAxis ?? 0.0).rounded(toPlaces: 5)
            unit = " µT"
        case .attitudeRoll:
            value = ((motionVM.coreMotionArray.last?.attitudeRoll ?? 0.0) * 180 / .pi).rounded(toPlaces: 5)
            unit = "°"
        case .attitudePitch:
            value = ((motionVM.coreMotionArray.last?.attitudePitch ?? 0.0) * 180 / .pi).rounded(toPlaces: 5)
            unit = "°"
        case .attitudeYaw:
            value = ((motionVM.coreMotionArray.last?.attitudeYaw ?? 0.0) * 180 / .pi).rounded(toPlaces: 5)
            unit = "°"
        case .attitudeHeading:
            value = ((motionVM.coreMotionArray.last?.attitudeHeading ?? 0.0)).rounded(toPlaces: 5)
            unit = "°"
        case .pressureValue:
            value = (motionVM.altitudeArray.last?.pressureValue ?? 0.0).rounded(toPlaces: 5)
            unit = " \(SettingsAPI.shared.fetchPressureSetting())"
        case .relativeAltitudeValue:
            value = (motionVM.altitudeArray.last?.relativeAltitudeValue ?? 0.0).rounded(toPlaces: 5)
            unit = " \(SettingsAPI.shared.fetchHeightSetting())"
        default:
            value = 0.0
            unit = ""
        }
        
        
        // MARK: - Return View
        return GeometryReader { g in
            AnyView(
                Text(NSLocalizedString(self.text, comment: "button") + " \(value)" + "\(unit)")
                    .font(.body)
                    .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .leading)
                    .foregroundColor(Color("StandardTextColor"))
                    .background(Color("StandardBackgroundColor"))
                    .cornerRadius(10)
                    .offset(x: 5)
            )
        }
    }
}


// MARK: - Preview
struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonView(type: .relativeAltitudeValue, text: "Pressure:")
                .previewLayout(.sizeThatFits)
            ButtonView(type: .relativeAltitudeValue, text: "Pressure:")
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .dark)
        }
    }
}
