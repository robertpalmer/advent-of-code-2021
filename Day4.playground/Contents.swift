import UIKit

struct Number: Equatable, Hashable {

    let value: Int
    let x: Int
    let y: Int
    var marked: Bool = false
}

struct Board {

    var numbers: [Number]
    let boardSize: Int

    var hitsPerRow: [Int]
    var hitsPerColumn: [Int]

    var winningNumber: Int?
    var winningMoves: Int = .max

    init(_ field: [String]) {

        boardSize = field.count

        numbers = field.enumerated().flatMap { yIndex, line in
            line.split(separator: " ").enumerated().map { xIndex, number in
                Number(
                    value: Int(number.trimmingCharacters(in: .whitespacesAndNewlines))!,
                    x: xIndex,
                    y: yIndex
                )
            }
        }

        hitsPerRow = Array(repeating: 0, count: boardSize)
        hitsPerColumn = Array(repeating: 0, count: boardSize)
    }

    mutating func playUntilWin(numbers: [Int]) {
        for (index, number) in numbers.enumerated() {

            apply(number: number)

            if hasWon() {
                winningMoves = index
                winningNumber = number
                return
            }
        }
    }

    func unmarkedNumberValue() -> Int {
        numbers
            .filter { !$0.marked }
            .map(\.value)
            .reduce(0, +)
    }

    private mutating func apply(number: Int) {
        if let index = numbers.firstIndex(where: { $0.value == number }) {
            var boardNumber = numbers[index]
            hitsPerRow[boardNumber.y] += 1
            hitsPerColumn[boardNumber.x] += 1
            boardNumber.marked = true

            numbers[index] = boardNumber
        }
    }

    private func hasWon() -> Bool {
        (hitsPerRow + hitsPerColumn).reduce(false) { $0 || $1 == boardSize }
    }
}

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = (try! String(contentsOf: file!, encoding: .utf8))
    .components(separatedBy: .newlines)

let drawnNumbers = input[0]
    .split(separator: ",")
    .map {Int($0)! }

let boards = input[2...]
    .reduce(into: (boards: [Board](), lines: [String]())) { total, line in
        if line.isEmpty {
            total.boards.append(Board(total.lines))
            total.lines = []
        } else {
            total.lines.append(String(line))
        }
    }

let playedBoards: [Board] = boards.boards.map {
    var board = $0
    board.playUntilWin(numbers: drawnNumbers)
    return board
}
.sorted(by: { $0.winningMoves < $1.winningMoves })

print("winner \(playedBoards.first!.unmarkedNumberValue() * playedBoards.first!.winningNumber!)")
print("loser \(playedBoards.last!.unmarkedNumberValue() * playedBoards.last!.winningNumber!)")

// Unit tests
var board = Board([" 1  2", "3 4"])
assert(board.numbers[0].value == 1)
assert(board.numbers[0].x == 0)
assert(board.numbers[0].y == 0)
assert(board.numbers[1].value == 2)
assert(board.numbers[1].x == 1)
assert(board.numbers[1].y == 0)
assert(board.numbers[2].value == 3)
assert(board.numbers[2].x == 0)
assert(board.numbers[2].y == 1)

board.playUntilWin(numbers: [1, 5, 5])
assert(board.numbers[0].marked == true)
assert(board.winningMoves == .max)
assert(board.winningNumber == nil)

board = Board(["1  2", "3 4"])
board.playUntilWin(numbers: [1, 5, 5, 4, 3])
assert(board.winningMoves == 4)
assert(board.winningNumber == 3)
assert(board.unmarkedNumberValue() == 2)
