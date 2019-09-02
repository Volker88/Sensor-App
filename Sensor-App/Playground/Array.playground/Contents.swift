import UIKit

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


