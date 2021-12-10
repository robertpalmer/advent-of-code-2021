import UIKit

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = Cave((try! String(contentsOf: file!, encoding: .utf8)))

extension Array where Element == Int {

    subscript(safe index: Int?) -> Element {
        get {
            guard let index = index, index >= 0 && index < count else { return Int.max }
            return self[index]
        }
    }
}

struct Cave {
    let size: Int
    let input: [Int]

    init(_ text: String) {
        let lines = text
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }

        size = lines[0].count
        input = lines.flatMap { $0.map { Int(String($0))! } }
    }

    func above(of index: Int) -> Int? {
        let value = index - size
        return value >= 0 ? value : nil
    }

    func below(of index: Int) -> Int? {
        let value = index + size
        return value < input.count ? value : nil
    }

    func left(of index: Int) -> Int? {
        let value = index - 1
        return value / size == index / size ? value : nil
    }

    func right(of index: Int) -> Int? {
        let value = index + 1
        return value / size == index / size ? value : nil
    }


    func isMinimum(at index: Int) -> Bool {
        let value = input[safe: index]

        return input[safe: left(of: index)] > value
            && input[safe: above(of: index)] > value
            && input[safe: right(of: index)] > value
            && input[safe: below(of: index)] > value
    }

    func minimums() -> [Int]
    {
        (0..<input.count)
            .filter { isMinimum(at: $0) }
    }

    func minimumValues() -> [Int]  {
        minimums().map { input[$0] }
    }

    func basinCount(at index: Int) -> Int {
        return Set(increase(previous: .min, index: index, visited: [])).count
    }

    func increase(previous: Int, index: Int?, visited: [Int]) -> [Int] {

        guard let index = index else { return [] }
        let value = input[safe: index]

        guard !visited.contains(index) else { return [] }
        guard value != .max, value != 9 else { return [] }
        guard previous < value else { return [] }

        return [index]
            + increase(previous: value, index: left(of: index), visited: visited + [index])
            + increase(previous: value, index: above(of: index), visited: visited + [index])
            + increase(previous: value, index: right(of: index), visited: visited + [index])
            + increase(previous: value, index: below(of: index), visited: visited + [index])
    }
}


func part1() -> Int {
    input.minimumValues()
        .map {  $0 + 1 }
        .reduce(0, +)
}

func part2() -> Int {
    let counts = input
        .minimums()
        .map { input.basinCount(at: $0) }
        .sorted(by: >)

    return counts[0..<3].reduce(1, *)
}

let result1 = part1()

let result2 = part2()
