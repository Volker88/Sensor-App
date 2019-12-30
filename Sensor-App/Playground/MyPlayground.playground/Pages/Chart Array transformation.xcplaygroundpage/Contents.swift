

var maxGraphHeight : Double = 300

var data : [Double] = [0,4,6,10,50,100,-20,-100,-200, 50, -300,4,6,10,50,100,-20,-100,-200, -300, -500]

var transformedArray = [Double]()


let dataArray = data

let dataArrayMaxValue = dataArray.map(abs).max()!

print("Max Value: \(dataArrayMaxValue)")

let scaleFactor : Double = maxGraphHeight / dataArrayMaxValue
print("Scale Factor: \(scaleFactor)")

let ar = dataArray.map() { $0 * scaleFactor }
print(dataArray)
print(ar)
