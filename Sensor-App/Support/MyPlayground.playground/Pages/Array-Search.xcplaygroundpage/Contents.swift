
// MARK: - Search Array Index
let searchFor = "km/h"
var searchID = 0
let speedSettings = ["m/s", "km/h", "mph"]


for i in speedSettings {
    
    searchID += 1
    
    if i == searchFor {
        break
    }
    
}

print(searchID)



// MARK: - Array Test
class DataArray {
    
    var id: Int
    var xaxis: Double
    var yaxis: Double
    
    init(_id: Int, _xaxis: Double, _yaxis: Double) {
        id = _id
        xaxis = _xaxis
        yaxis = _yaxis
    }
}


var testArray = [DataArray]()


for i in 0..<100 {
    testArray.insert(DataArray(_id: i, _xaxis: 1.0, _yaxis: 2.0), at: i)
}

print(testArray.last!.id)


let arr = ["a","b","c","a"]

let indexOfA = arr.firstIndex(of: "a") // 0
let indexOfB = arr.lastIndex(of: "a") // 3

