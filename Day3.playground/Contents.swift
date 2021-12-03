import Foundation

typealias Bits = [Int]

extension Array where Element == Int {
    init(_ texts: String) {
        self = texts.map { Int(String($0))! }
    }
}

extension Collection where Element == Int {

    var asDecimal: Int {

        let string = self
            .map { String($0) }
            .joined(separator: "")

        return Int(string, radix: 2)!
    }
}

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = (try! String(contentsOf: file!, encoding: .utf8))
    .split(separator: "\n")
    .map { Bits(String($0)) }

let totalPerPosition = input
    .reduce(Array(repeating: 0, count: input[0].count)) { result, bits in
        zip(result, bits).map { $0 + $1 }
    }

let gamma = totalPerPosition
    .map { $0 > input.count / 2 ? 1 : 0 }
    .asDecimal

let epsilon = totalPerPosition
    .map { $0 < input.count / 2 ? 1 : 0 }
    .asDecimal

print("\(gamma), \(epsilon) \(gamma * epsilon)")

// Part 2
func filter(_ input: [Bits], compare: @escaping (Int, Int) -> Bool, at position: Int = 0) -> [Bits] {

    guard input.count > 1, position < input[0].count else { return input }

    let onesCount = input.filter { $0[position] == 1 }.count
    let winnerBit = compare(onesCount, input.count - onesCount) ? 1 : 0

    let restInput = input.filter { $0[position] == winnerBit }

    return filter(restInput, compare: compare, at: position + 1)
}

let oxygen = filter(input, compare: >=).first!.asDecimal
let co2Srcubber = filter(input, compare: <).first!.asDecimal

print("\(oxygen), \(co2Srcubber) \(oxygen * co2Srcubber)")
