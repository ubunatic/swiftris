import Foundation

class Game: View {
    var board: [[Int]]
    var score: Int
    var level: Int
    var lines: Int
    var nextPiece: Int
    var currPiece: Int
    var rotation: Int
    var x: Int
    var y: Int

    override init(_ next: View? = nil) {
        board = Array(repeating: Array(repeating: 0, count: 10), count: 20)
        score = 0
        level = 1
        lines = 0
        nextPiece = Int.random(in: 0..<7)
        currPiece = 0
        rotation = 0
        x = 0
        y = 0
        super.init(next)
        spawnPiece()
    }

    func spawnPiece() {
        currPiece = nextPiece
        rotation = 0
        nextPiece = Int.random(in: 0..<7)
        x = 4
        y = 4
        setPiece()
    }

    func setPiece(val: Int = 1) {
        let p = getShape(rotation)
        for i in 0..<4 {
            for j in 0..<4 {
                if p.shape[i][j] == 1 {
                    board[y + i][x + j] = val
                }
            }
        }
    }

    func getRotation(_ dir: Int) -> Int {
        switch currPiece {
        case 0: // O
            return 0
        case 6: // I
            return rotation == 0 ? 1 : 0
        default:
            return (rotation + dir + 4) % 4
        }
    }

    // rotatePiece rotates the current piece if possible.
    // The default rotation center is (x:1, y:2) from top left.
    // "O" piece is not rotated (4x4 grid is symmetrical).
    // "I" piece is rotated such that it does not leave the 4x4 grid (it just flips between horizontal and vertical).
    // Other pieces are rotated around the center (1, 2).
    func getShape() -> Piece { return getShape(nil) }
    func getShape(_ rotation: Int?) -> Piece {
        let rot = rotation ?? self.rotation
        return Piece.new(currPiece, rotation: rot)
    }

    override func render(_ t: Terminal) {
        var screen = [String]()
        for i in 0..<20 {
            var line = ""
            for j in 0..<10 {
                var color = board[i][j]
                if color == 1 {
                    color = getShape().color
                }
                switch color {
                case 0:  line.append("　")
                case 10: line.append("🟦")
                case 11: line.append("🟪")
                case 12: line.append("🟥")
                case 13: line.append("🟩")
                case 14: line.append("🟧")
                case 15: line.append("⬜️")
                case 16: line.append("🟨")
                default: line.append("　")
                }
            }
            screen.append("|" + line + "|")
        }

        screen = ["┌────────────────────┐"]
               + screen
               + ["└────────────────────┘"]

        screen[1].append("  Score: \(score)")
        screen[2].append("  Level: \(level)")
        screen[3].append("  Lines: \(lines)")

        plot(screen)
        super.render(t)
    }

    func canMove(x: Int, y: Int) -> Bool {
        return canMove(x: x, y: y, shape: getShape().shape)
    }

    func canMove(x: Int, y: Int, shape: [[Int]]?) -> Bool {
        let shape = shape ?? getShape().shape

        print("canMove", x, y)
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
                    if board[ny][nx] > 1 {
                        print("canMove failed at board", nx, ny)
                        return false
                    }
                }
            }
        }
        return true
    }

    func canRotate(dir: Int) -> Bool {
        let shape = getShape(getRotation(dir)).shape
        return canMove(x: x, y: y, shape: shape)
    }

    func dropPiece() {
        while canMove(x: x, y: y + 1) {
            y += 1
        }
        setPiece(val: getShape().color)
        // checkLines()
        spawnPiece()
    }

    func updateBoard() {
        for i in 0..<20 {
            for j in 0..<10 {
                if board[i][j] == 1 {
                    board[i][j] = 0
                }
            }
        }
        setPiece()
    }

    override func handleKey(_ k: Key) -> View? {
        // do not call super.handleKey(k), all keys are handled here
        switch k {
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
            if canRotate(dir: 1) {
                rotation = getRotation(1)
            }
        case .space:
            while canMove(x: x, y: y + 1) {
                y += 1
            }
            dropPiece()
        case .Q, .q:
            return Exit()
        case .H, .h:
            return Help(self)
        default:
            break
        }
        updateBoard()
        return nil
    }
}