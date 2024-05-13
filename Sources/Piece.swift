import Foundation

struct Piece {
    var name: String
    var color: Int
    var shape: [[Int]]

    static let O = Piece(name: "O", color: 10, shape: [
        [0, 0, 0, 0],
        [0, 1, 1, 0],
        [0, 1, 1, 0],
        [0, 0, 0, 0],
    ])

    static let T = Piece(name: "T", color: 11, shape: [
        [0, 0, 0, 0],
        [0, 1, 0, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0]
    ])
    static let L = Piece(name: "L", color: 12, shape: [
        [0, 0, 0, 0],
        [0, 0, 1, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0]
    ])
    static let S = Piece(name: "S", color: 13, shape: [
        [0, 0, 0, 0],
        [0, 1, 1, 0],
        [1, 1, 0, 0],
        [0, 0, 0, 0]
    ])
    static let Z = Piece(name: "Z", color: 14, shape: [
        [0, 0, 0, 0],
        [1, 1, 0, 0],
        [0, 1, 1, 0],
        [0, 0, 0, 0]
    ])
    static let J = Piece(name: "J", color: 15, shape: [
        [0, 0, 0, 0],
        [1, 0, 0, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0]
    ])
    static let I = Piece(name: "I", color: 16, shape: [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0, 0, 0, 0]
    ])

    static func new(_ num:Int, rotation: Int = 0) -> Piece {
        var p: Piece
        switch num {
        case 0: p = Piece.O
        case 1: p = Piece.T
        case 2: p = Piece.L
        case 3: p = Piece.S
        case 4: p = Piece.Z
        case 5: p = Piece.J
        case 6: p = Piece.I
        default: p = Piece.O
        }
        if rotation > 0 {
            p = p.rotated(rotation)
        }
        return p
    }

    func rotated(_ rotation: Int = 0) -> Piece {
        var shape = [
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ]
        let src = self.shape

        switch rotation {
        case 1:
            for i in 0..<4 {
                for j in 0..<4 {
                    shape[j][3 - i] = src[i][j]
                }
            }
        case 2:
            for i in 0..<4 {
                for j in 0..<4 {
                    shape[3 - i][3 - j] = src[i][j]
                }
            }
        case 3:
            for i in 0..<4 {
                for j in 0..<4 {
                    shape[3 - j][i] = src[i][j]
                }
            }
        default:
            for i in 0..<4 {
                for j in 0..<4 {
                    shape[i][j] = src[i][j]
                }
            }
        }
        return Piece(name: name, color: color, shape: shape)
    }
}