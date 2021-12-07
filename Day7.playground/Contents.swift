import UIKit

let testInput = [16,1,2,0,4,2,7,1,2,14]

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = (try! String(contentsOf: file!, encoding: .utf8))
    .components(separatedBy: ",")
    .map { Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! }

func countPositions(_ input: [Int]) -> [Int: Int] {
    input.reduce(into: [:]) { $0[$1] = $0[$1, default: 0] + 1 }
}

func calulateMoves(input: [Int: Int], goalPosition: Int, costCalculation: (Int) -> Int) -> Int {
    input.reduce(0) { total, value in
        total + value.value * costCalculation(abs(value.key - goalPosition))
    }
}

func minimum(input: [Int: Int], costCalculation: (Int) -> Int) -> Int {
    (input.keys.min()!..<input.keys.max()!)
        .map { calulateMoves(input: input, goalPosition: $0, costCalculation: costCalculation) }
        .min()!
}

let positions = countPositions(input)
print("result 1 \(minimum(input: positions, costCalculation: { $0 }))")
print("result 2 \(minimum(input: positions, costCalculation: { $0 * ($0 + 1) / 2 }))")
