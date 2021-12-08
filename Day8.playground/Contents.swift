import UIKit

struct DisplayObservation
{
    let input: [String]
    let output: [String]

    init(_ text: String) {
        let parts = text.split(separator: "|").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        input = parts[0].split(separator: " ").map { String($0) }
        output = parts[1].split(separator: " ").map { String($0) }
    }

    private var onePattern: Set<Character> {
        Set(input.first(where: { $0.count == 2 })!)
    }

    private var fourPattern: Set<Character> {
        Set(input.first(where: { $0.count == 4})!)
    }

    func convert(pattern: Set<Character>) -> String
    {
        switch (pattern.count,
                pattern.subtracting(onePattern).count,
                pattern.subtracting(fourPattern).count)
        {

            case (6, 4, 3): return "0"
            case (2, _, _): return "1"
            case (5, 4, 3): return "2"
            case (5, 3, 2): return "3"
            case (4, _, _): return "4"
            case (5, 4, 2): return "5"
            case (6, 5, 3): return "6"
            case (3, _, _): return "7"
            case (7, _, _): return "8"
            case (6, 4, 2): return "9"

            default: fatalError()
        }
    }

    var outputValue: Int {
        Int(output.map { convert(pattern: Set($0)) }.joined())!
    }
}

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = (try! String(contentsOf: file!, encoding: .utf8))
    .components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
    .map { DisplayObservation($0) }

// Part 1
func part1(_ measurements: [DisplayObservation]) -> Int {
    measurements
        .flatMap { $0.output }
        .filter { [2, 4, 3, 7].contains($0.count) }
        .count
}

let result1 = part1(input)

// Part 2
func part2(_ measurements: [DisplayObservation]) -> Int {
    measurements.map(\.outputValue).reduce(0, +)
}

let result2 = part2(input)


// Tests
let measurement = DisplayObservation("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf")

measurement.convert(pattern: Set("ab"))
measurement.convert(pattern: Set("cdfeb"))
measurement.convert(pattern: Set("fcadb"))
measurement.convert(pattern: Set("acedgfb"))
measurement.convert(pattern: Set("gcdfa"))
measurement.convert(pattern: Set("dab"))
measurement.convert(pattern: Set("cefabd"))
measurement.convert(pattern: Set("cdfgeb"))
measurement.convert(pattern: Set("eafb"))
measurement.convert(pattern: Set("cagedb"))
