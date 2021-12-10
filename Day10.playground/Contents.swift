import UIKit

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = (try! String(contentsOf: file!, encoding: .utf8)
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty} )
            .map(Line.init)

enum Bracket {
    case round
    case square
    case curly
    case angle

    var errorScore: Int {
        switch self {
            case .round:
                return 3
            case .square:
                return 57
            case .curly:
                return 1197
            case .angle:
                return 25137
        }
    }

    var completionScore: Int {
        switch self {
            case .round:
                return 1
            case .square:
                return 2
            case .curly:
                return 3
            case .angle:
                return 4
        }
    }
}

enum Command {
    case open(Bracket)
    case close(Bracket)

    init(_ text: String)
    {
        switch text {
            case "(":
                self = .open(.round)
            case ")":
                self = .close(.round)
            case "[":
                self = .open(.square)
            case "]":
                self = .close(.square)
            case "{":
                self = .open(.curly)
            case "}":
                self = .close(.curly)
            case "<":
                self = .open(.angle)
            case ">":
                self = .close(.angle)
            default:
                fatalError("wrong input")
        }
    }
}

struct Line
{
    let line: [Command]

    init(_ text: String) {
        line = text.map { Command(String($0)) }
    }

    func evaluate() -> (error: Bracket?, rest: [Bracket]) {

        var stack: [Bracket] = []

        for command in line {
            switch command {
                case let .open(bracketType):
                    stack.append(bracketType)
                case let .close(bracketType):
                    if stack.popLast() != bracketType {
                        return (bracketType, stack)
                    }
            }
        }

        return (nil, stack)
    }
}

extension Collection where Element == Bracket {

    var score: Int {
        self.enumerated()
            .reduce(0) { acc, value in
                acc * 5 + value.element.completionScore
            }
    }
}

func part1() -> Int {
    input
        .compactMap { $0.evaluate().error?.errorScore }.reduce(0, +)
}

let result1 = part1()

func part2() -> Int {
    let results = input
        .map { $0.evaluate() }
        .filter { $0.error == nil }
        .map { $0.rest.reversed().score }
        .sorted(by: <)

    return results[results.count / 2]
}

let result2 = part2()

