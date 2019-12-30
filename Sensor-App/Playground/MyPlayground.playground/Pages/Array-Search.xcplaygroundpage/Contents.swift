
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
    
    init(id: Int, xaxis: Double, yaxis: Double) {
        self.id = id
        self.xaxis = xaxis
        self.yaxis = yaxis
    }
}


var testArray = [DataArray]()


for i in 0..<100 {
    testArray.insert(DataArray(id: i, xaxis: 1.0, yaxis: 2.0), at: i)
}

print(testArray.last!.id)


let arr = ["a","b","c","a"]

let indexOfA = arr.firstIndex(of: "a") // 0
let indexOfB = arr.lastIndex(of: "a") // 3

