import Foundation

let number = 5.12
let formatter = NumberFormatter()
formatter.numberStyle = .decimal
formatter.maximumFractionDigits = 15
let localized = formatter.string(from: NSNumber(value: number))
