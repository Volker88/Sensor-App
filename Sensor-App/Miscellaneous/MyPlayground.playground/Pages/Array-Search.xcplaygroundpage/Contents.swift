// MARK: - Search Array Index
let searchFor = "km/h"
var searchID = 0
let speedSettings = ["m/s", "km/h", "mph"]

for index in speedSettings {

    searchID += 1

    if i == searchFor {
        break
    }

}

print(searchID)

// MARK: - Array Test
class DataArray {

    var id: Int
    var xAxis: Double
    var yAxis: Double

    init(id: Int, xaxis: Double, yaxis: Double) {
        self.id = id
        self.xAxis = xaxis
        self.yAxis = yaxis
    }
}

var testArray = [DataArray]()

for index in 0..<100 {
    testArray.insert(DataArray(id: i, xaxis: 1.0, yaxis: 2.0), at: index)
}

print(testArray.last!.id)  // swiftlint:disable:this force_unwrapping

let arr = ["a", "b", "c", "a"]

let indexOfA = arr.firstIndex(of: "a")  // 0
let indexOfB = arr.lastIndex(of: "a")  // 3
