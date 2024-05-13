
struct Key {
    // static let none = Key(rawValue: -1)
    static let backspace = Key(rawValue: 127)
    static let enter = Key(rawValue: 10)
    static let `return` = Key(rawValue: 13)
    static let esc = Key(rawValue: 27)
    static let space = Key(rawValue: 32)

    static let up = Key(rawValue: 1065)
    static let down = Key(rawValue: 1066)
    static let left = Key(rawValue: 1068)
    static let right = Key(rawValue: 1067)

    static let A = Key(rawValue: 65)
    static let a = Key(rawValue: 97)
    static let B = Key(rawValue: 66)
    static let b = Key(rawValue: 98)
    static let C = Key(rawValue: 67)
    static let c = Key(rawValue: 99)
    static let d = Key(rawValue: 100)
    static let D = Key(rawValue: 68)
    static let e = Key(rawValue: 101)
    static let E = Key(rawValue: 69)
    static let f = Key(rawValue: 102)
    static let F = Key(rawValue: 70)
    static let g = Key(rawValue: 103)
    static let G = Key(rawValue: 71)
    static let h = Key(rawValue: 104)
    static let H = Key(rawValue: 72)
    static let i = Key(rawValue: 105)
    static let I = Key(rawValue: 73)
    static let j = Key(rawValue: 106)
    static let J = Key(rawValue: 74)
    static let k = Key(rawValue: 107)
    static let K = Key(rawValue: 75)
    static let l = Key(rawValue: 108)
    static let L = Key(rawValue: 76)
    static let m = Key(rawValue: 109)
    static let M = Key(rawValue: 77)
    static let n = Key(rawValue: 110)
    static let N = Key(rawValue: 78)
    static let o = Key(rawValue: 111)
    static let O = Key(rawValue: 79)
    static let p = Key(rawValue: 112)
    static let P = Key(rawValue: 80)
    static let q = Key(rawValue: 113)
    static let Q = Key(rawValue: 81)
    static let r = Key(rawValue: 114)
    static let R = Key(rawValue: 82)
    static let s = Key(rawValue: 115)
    static let S = Key(rawValue: 83)
    static let t = Key(rawValue: 116)
    static let T = Key(rawValue: 84)
    static let u = Key(rawValue: 117)
    static let U = Key(rawValue: 85)
    static let v = Key(rawValue: 118)
    static let V = Key(rawValue: 86)
    static let w = Key(rawValue: 119)
    static let W = Key(rawValue: 87)
    static let x = Key(rawValue: 120)
    static let X = Key(rawValue: 88)
    static let y = Key(rawValue: 121)
    static let Y = Key(rawValue: 89)
    static let z = Key(rawValue: 122)
    static let Z = Key(rawValue: 90)

    static func fromChar(_ c: Int16) -> Key { return Key(rawValue: c) }
    static func fromChar(_ c: Int8) -> Key { return Key(rawValue: Int16(c)) }
    let rawValue: Int16
}

extension Key: Equatable {
    static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Key: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension Key: CustomStringConvertible {
    var description: String {
        switch self {
        case .backspace: return "backspace"
        case .enter: return "enter"
        case .return: return "return"
        case .up: return "up"
        case .down: return "down"
        case .left: return "left"
        case .right: return "right"
        case .esc: return "esc"
        case .space: return "space"
        // case .none: return "none"
        default: return String(UnicodeScalar(UInt8(rawValue)))
        }
    }
}
