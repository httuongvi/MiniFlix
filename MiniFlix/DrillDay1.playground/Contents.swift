import UIKit

//bai1
func fizzBuzz(_ n: Int){
    for i in 1...n {
        if i % 3 == 0 && i % 5 == 0 {
            print("FizzBuzz tại \(i)")
        }
        else if i % 3 == 0 {
            print("Fizz tại \(i)")
        }
        else if i % 5 == 0 {
            print("Buzz tại \(i)")
        }
        else{
            print(i)
        }
    }
    
}

fizzBuzz(15)

//bai 2
func phanTichMangSo(_ arr: [Int]) -> (max: Int, min: Int, ave: Double) {
    var max = arr[0]
    var min = arr[0]
    var sum = 0
    
    for number in arr {
        sum += number
        if number > max {
            max = number
        }
        if number < min {
            min = number
        }
    }
    
    let ave = Double(sum) / Double(arr.count)
    return (max, min, ave)
}

phanTichMangSo([1, 6, 4, 0, 5, 5, 3, 3])

//bai 3
let chuoi = "I'm a barbie girl in a barbie world"
let arrChar = chuoi.components(separatedBy: " ")
var dictionary: [String: Int] = [:]
for char in arrChar{
    if let soLanXuatHien = dictionary[char]{
        dictionary[char] = soLanXuatHien + 1
    } else {
        dictionary[char] = 1
    }
    
}

print(dictionary)

