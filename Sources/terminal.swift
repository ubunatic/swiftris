import Foundation
import Darwin

let Esc = "\u{1b}"
let ClearString = "\(Esc)[2J"
let GotoTop = "\(Esc)[0;0H"

func esc(_ string: String, _ code: String = "0;0m") -> String { return "\(Esc)[\(code)\(string)\(Esc)[0m" }
func bold(_ string: String)       -> String { return esc(string, "1m") }
func bold_white(_ string: String) -> String { return esc(string, "1;37m") }
func goto(x: Int16, y: Int16)     -> String { return "\(Esc)[\(x);\(y)H" }
func clear()                      -> String { return ClearString }

enum TerminalError: Error {
    case get
    case makeRaw
    case restore
}

class Terminal {
    let fd = STDIN_FILENO
    var tio: termios = termios()            // original terminal settings
    var pio: UnsafeMutablePointer<termios>! // pointer to original terminal settings

    init() { setPio(&tio) }
    deinit { try? restore() }

    func setPio(_ tio: UnsafeMutablePointer<termios>){ pio = tio }

    func decorate() {
        // print(goto(x: 0, y: 0))
        // print(bold("Swiftris"), terminator: "")
    }

    func makeRaw() throws {
        guard isatty(fd) != 0 else {
            Swift.print("failed to get terminal")
            throw TerminalError.get
        }
        // get the original terminal settings
        guard tcgetattr(fd, &pio.pointee) >= 0 else  {
            Swift.print("failed to get terminal settings")
            throw TerminalError.get
        }
        var tio = pio.pointee
        tio.c_iflag &= ~UInt(IXON | ICRNL | ISTRIP | BRKINT) // disable software flow control
        tio.c_oflag &= ~UInt(OPOST)                          // disable output processing
        tio.c_cflag &= ~UInt(CS8)                            // set character size to 8 bits
        tio.c_lflag &= ~UInt(ICANON | ECHO | ISIG | IEXTEN)  // disable canonical mode, echo, signals, and extended input processing
        guard tcsetattr(fd, TCSAFLUSH, &tio) >= 0 else {
            Swift.print("failed to set terminal to raw mode")
            throw TerminalError.makeRaw
        }
        tcflush(fd, TCIOFLUSH)
    }

    func restore() throws {
        guard tcsetattr(fd, TCSAFLUSH, &pio.pointee) >= 0 else {
            Swift.print("failed to disable raw mode")
            throw TerminalError.restore
        }
    }

    func print(_ items: Any..., separator: String = " ", terminator: String = "\n\r") {
        let text = items.map { "\($0)" }.joined(separator: separator) + terminator
        Darwin.write(fd, text, text.utf8.count)
    }

    func goto(x: Int16, y: Int16) { print("\(Esc)[\(x);\(y)H") }

    func getch() -> Int8 {
        var c: Int8 = 0
        Darwin.read(fd, &c, 1)
        return c
    }

    func readKey() -> Key {
        let c = getch()
        switch c {
        case 127: return .backspace
        case 10: return .enter
        case 27:
            let c2 = getch()
            let c3 = getch()
            if c2 == 91 {
                switch c3 {
                case 65: return .up
                case 66: return .down
                case 67: return .right
                case 68: return .left
                default: return .esc
                }
            }
            return .esc
        default: return .char(c)
        }
    }
}
