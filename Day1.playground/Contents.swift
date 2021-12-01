import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = (try! String(contentsOf: file!, encoding: .utf8)).split(separator: "\n").map { Int($0)! }

func increaseCount(_ input: [Int]) -> Int {
    zip(input, input[1...])
        .reduce(0) { amount, values in values.0 < values.1 ? amount + 1 : amount }
}

print("Part 1: \(increaseCount(input))")

let summedInput = zip(zip(input, input[1...]), input[2...]).map { ($0.0 + $0.1 + $1) }

print("Part 2: \(increaseCount(summedInput))")
