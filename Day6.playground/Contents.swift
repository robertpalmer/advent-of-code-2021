import UIKit

let testInput = [3, 4, 3, 1, 2]

let input = "1,2,1,1,1,1,1,1,2,1,3,1,1,1,1,3,1,1,1,5,1,1,1,4,5,1,1,1,3,4,1,1,1,1,1,1,1,5,1,4,1,1,1,1,1,1,1,5,1,3,1,3,1,1,1,5,1,1,1,1,1,5,4,1,2,4,4,1,1,1,1,1,5,1,1,1,1,1,5,4,3,1,1,1,1,1,1,1,5,1,3,1,4,1,1,3,1,1,1,1,1,1,2,1,4,1,3,1,1,1,1,1,5,1,1,1,2,1,1,1,1,2,1,1,1,1,4,1,3,1,1,1,1,1,1,1,1,5,1,1,4,1,1,1,1,1,3,1,3,3,1,1,1,2,1,1,1,1,1,1,1,1,1,5,1,1,1,1,5,1,1,1,1,2,1,1,1,4,1,1,1,2,3,1,1,1,1,1,1,1,1,2,1,1,1,2,3,1,2,1,1,5,4,1,1,2,1,1,1,3,1,4,1,1,1,1,3,1,2,5,1,1,1,5,1,1,1,1,1,4,1,1,4,1,1,1,2,2,2,2,4,3,1,1,3,1,1,1,1,1,1,2,2,1,1,4,2,1,4,1,1,1,1,1,5,1,1,4,2,1,1,2,5,4,2,1,1,1,1,4,2,3,5,2,1,5,1,3,1,1,5,1,1,4,5,1,1,1,1,4"
    .components(separatedBy: ",")
    .map { Int($0)! }

var cache: [Int: Int] = [:]

func ancestors(days: Int) -> Int {

    if cache[days] == nil {
        guard days > 8 else { return 0 }

        let children = 1 + ((days - 9) / 7)
        let grandChildren = (0..<children).reduce(0) { $0 + ancestors(days: days - (($1 + 1) * 7) - 2) }

        cache[days] = children + grandChildren
    }

    return cache[days]!
}

func population(after days: Int, start: [Int]) -> Int {
    start.reduce(start.count) { $0 + ancestors(days: days + (8 - $1)) }
}

print("part 1 \(population(after: 80, start: input))")
print("part 2 \(population(after: 256, start: input))")
