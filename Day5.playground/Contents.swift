import UIKit

struct Point: Equatable {
    let x: Int
    let y: Int
}

extension Point {
    init(_ text: String) {
        let parts = text.split(separator: ",")
        (x, y) = (Int(parts[0])!, Int(parts[1])!)
    }
}

struct LineOfVent {
    let start: Point
    let end: Point

    init(_ text: String) {
        let parts = text.components(separatedBy: " -> ")
        start = .init(parts[0])
        end = .init(parts[1])
    }

    var diagonalPoints: [Point] {
        if start.y == end.y, start.x <= end.x {
            return (start.x...end.x).map { Point(x: $0, y: start.y) }
        } else if start.y == end.y {
            return (end.x...start.x).map { Point(x: $0, y: start.y) }
        } else if start.x == end.x, start.y <= end.y {
            return (start.y...end.y).map { Point(x: start.x, y: $0) }
        } else if start.x == end.x {
            return (end.y...start.y).map { Point(x: start.x, y: $0) }
        } else {
            return []
        }
    }

    var points: [Point] {
        if start.x == end.x || start.y == end.y {
            return diagonalPoints
        } else {
            return zip(valuesBetween(start: start.x, end: end.x), valuesBetween(start: start.y, end: end.y)).map {
                Point(x: $0, y: $1)
            }
        }
    }
}

func valuesBetween(start: Int, end: Int) -> [Int] {
    let difference = end - start
    return (0...abs(difference)).map {
        start + ($0 * difference.signum())
    }
}

struct Diagram {
    private var diagram: [[Int]] = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)

    mutating func applyOnlyDiagonal(line: LineOfVent) {
        line.diagonalPoints.forEach {
            diagram[$0.x][$0.y] += 1
        }
    }

    mutating func apply(line: LineOfVent) {
        line.points.forEach {
            diagram[$0.x][$0.y] += 1
        }
    }

    var overlapCount: Int {
        diagram.reduce(0) {
            $0 + $1.filter { $0 > 1}.count
        }
    }
}

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = (try! String(contentsOf: file!, encoding: .utf8))
    .components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
    .map { LineOfVent($0) }


func part1() -> Int {
    var diagram = Diagram()
    input.forEach {
        diagram.applyOnlyDiagonal(line: $0)
    }

    return diagram.overlapCount
}

func part2() -> Int  {
    var diagram = Diagram()
    input.forEach {
        diagram.apply(line: $0)
    }

    return diagram.overlapCount
}

print("part 1 \(part1())")
print("part 2 \(part2())")

// Unit Test
let vents = LineOfVent("1,1 -> 3,3")
assert(vents.diagonalPoints == [])

let vents2 = LineOfVent("1,1 -> 1,3")
assert(vents2.points == [Point(x: 1, y: 1), Point(x: 1, y: 2), Point(x: 1, y: 3)])

let vents3 = LineOfVent("9,7 -> 7,7")
assert(vents3.points == [Point(x: 7, y: 7), Point(x: 8, y: 7), Point(x: 9, y: 7)])

let vents4 = LineOfVent("1,1 -> 3,3")
assert(vents4.points == [Point(x: 1, y: 1), Point(x: 2, y: 2), Point(x: 3, y: 3)])

let vents5 = LineOfVent("9,7 -> 7,9")
assert(vents5.points == [Point(x: 9, y: 7), Point(x: 8, y: 8), Point(x: 7, y: 9)])


