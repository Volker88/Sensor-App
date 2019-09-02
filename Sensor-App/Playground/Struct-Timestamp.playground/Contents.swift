import UIKit


// MARK: - Struct for DataArrays
struct dataValues {
    var id : [Int] = []
    var timestamp : [String] = []
    var xAxis : [String] = []
}

var data = dataValues()

data.id.insert(1, at: 0)
data.timestamp.insert("test1", at: 0)
data.xAxis.insert("23.23", at: 0)

print(data.id[0])


// MARK: - Timestamp
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss.SSS"
let dateString = dateFormatter.string(from: NSDate() as Date)
print(dateString)


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
