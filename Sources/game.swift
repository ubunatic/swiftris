import Foundation

class Game: View {
    var board: [[Int]]
    var score: Int
    var level: Int
    var lines: Int
    var nextPiece: Int
    var piece: Int
    var x: Int
    var y: Int

    let pieces = [
        [ // O
            [0, 0, 0, 0],
            [0, 1, 1, 0],
            [0, 1, 1, 0],
            [0, 0, 0, 0]
        ],
        [ // T
            [0, 0, 0, 0],
            [0, 0, 1, 0],
            [0, 1, 1, 1],
            [0, 0, 0, 0]

        ],
        [ // L
            [0, 0, 0, 0],
            [0, 0, 1, 0],
            [1, 1, 1, 0],
            [0, 0, 0, 0]
        ],
        [// S
            [0, 0, 0, 0],
            [0, 1, 1, 0],
            [1, 1, 0, 0],
            [0, 0, 0, 0]
        ],
        [ // Z
            [0, 0, 0, 0],
            [1, 1, 0, 0],
            [0, 1, 1, 0],
            [0, 0, 0, 0]
        ],
        [ // J
            [0, 0, 0, 0],
            [1, 0, 0, 0],
            [1, 1, 1, 0],
            [0, 0, 0, 0]
        ],
        [ // I
            [0, 0, 0, 0],
            [1, 1, 1, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ]
    ]
    override init(_ next: View? = nil) {
        board = Array(repeating: Array(repeating: 0, count: 10), count: 20)
        score = 0
        level = 1
        lines = 0
        nextPiece = Int.random(in: 0..<7)
        piece = 0
        x = 0
        y = 0
        super.init(next)
        spawnPiece()
    }

    func spawnPiece() {
        piece = nextPiece
        nextPiece = Int.random(in: 0..<7)
        x = 4
        y = 4
        setPiece()
    }

    func setPiece() {
        let shape = pieces[piece]
        for i in 0..<4 {
            for j in 0..<4 {
                if shape[i][j] == 1 {
                    board[y + i][x + j] = 1
                }
            }
        }
    }

    override func render(_ t: Terminal) {
        var screen = [
            "Score: \(score)",
            "Level: \(level)",
            "Lines: \(lines)",
            "",
            "┌────────────────────┐",
        ]
        for i in 0..<20 {
            var line = "│"
            for j in 0..<10 {
                line.append(board[i][j] == 0 ? "　" : "🟨")
            }
            line.append("│")
            screen.append(line)
        }
        screen.append("└────────────────────┘")
        plot(screen)
        super.render(t)
    }

    func canMove(x: Int, y: Int) -> Bool {
        print("canMove", x, y)
        let shape = pieces[piece]
        for i in 0..<4 {
            for j in 0..<4 {
                if shape[i][j] == 1 {
                    let nx = x + j
                    let ny = y + i
                    if nx < 0 || nx >= 10 {
                        print("canMove failed at", nx)
                        return false
                    }
                    if ny < 0 || ny >= 20 {
                        print("canMove failed at ny", ny)
                        return false
                    }
                    // TODO: check collision (excl. self)
                    // if board[ny][nx] == 1 {
                    //     print("canMove failed at board", nx, ny)
                    //     return false
                    // }
                }
            }
        }
        return true
    }

    func updateBoard() {
        for i in 0..<20 {
            for j in 0..<10 {
                board[i][j] = 0
            }
        }
        setPiece()
    }

    override func read(_ t: Terminal) -> Bool {
        let ok = super.read(t)
        switch key {
        case .Q, .q:
            next = Exit()
            return false
        case .H, .h:
            next = Help(self)
            return false
        case .left:
            if canMove(x: x - 1, y: y) {
                x -= 1
            }
        case .right:
            if canMove(x: x + 1, y: y) {
                x += 1
            }
        case .down:
            if canMove(x: x, y: y + 1) {
                y += 1
            }
        case .up:
            if canMove(x: x, y: y - 1) {
                y -= 1
            }
        case .space:
            while canMove(x: x, y: y + 1) {
                y += 1
            }
        default:
            return ok
        }
        updateBoard()
        return ok
    }
}