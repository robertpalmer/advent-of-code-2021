import Foundation

enum Command: String {
    case forward
    case down
    case up
}

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = (try! String(contentsOf: file!, encoding: .utf8))
    .split(separator: "\n")
    .map { $0.split(separator: " ") }
    .map { (Command(rawValue: String($0[0]))!, Int($0[1])!) }

func navigate(_ input: [(direction: Command, x: Int)]) -> (Int, Int) {

    input.reduce((horiontal: 0, depth: 0)) { total, input in
        switch input.direction {
            case .forward:
                return (total.0 + input.x, total.1)
            case .down:
                return (total.0, total.1 + input.x)
            case .up:
                return (total.0, total.1 - input.x)
        }
    }
}

let result1 = navigate(input)
print("result \(result1) product: \(result1.0 * result1.1)")

// -----------------------------------------------------------------------
func navigate2(_ input: [(direction: Command, x: Int)]) -> (horizontal: Int, depth: Int, aim: Int) {

    input.reduce(into: (horizontal: 0, depth: 0, aim: 0)) { total, input in
        switch input.direction {
            case .forward:
                total.horizontal += input.x
                total.depth += total.aim * input.x
            case .down:
                total.aim += input.x
            case .up:
                total.aim -= input.x
        }
    }
}

let result2 = navigate2(input)
print("result \(result2) product: \(result2.horizontal * result2.depth)")
