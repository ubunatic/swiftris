import Foundation
import Darwin

#if DEBUG
let DEBUG = true
#else
let env = ProcessInfo.processInfo.environment
let DEBUG = env["DEBUG"] != nil && env["DEBUG"] != ""
#endif

let Esc = "\u{1b}"
let ClearString = "\(Esc)[2J"
let GotoTop = "\(Esc)[0;0H"

func esc(_ string: String, _ code: String = "0;0m") -> String { return "\(Esc)[\(code)\(string)\(Esc)[0m" }
func bold(_ string: String)       -> String { return esc(string, "1m") }
func bold_white(_ string: String) -> String { return esc(string, "1;37m") }
func invert(_ string: String)     -> String { return esc(string, "7m") }
func goto(x: Int16, y: Int16)     -> String { return "\(Esc)[\(x);\(y)H" }
func clear()                      -> String { return ClearString }

enum TerminalError: Error {
    case get
    case makeRaw
    case restore
}

private var tio = termios()
private func originalTerimos() -> UnsafeMutablePointer<termios> {
    return UnsafeMutablePointer<termios>(&tio)
}

class Terminal {
    let fd = STDIN_FILENO
    var key: Key?
    var log: [String] = []

    deinit {
        do { try restore(); debug("restored terminal settings") }
        catch { debug("terminal stopped with error: \(error)") }
    }

    func decorate() {
        // print(goto(x: 0, y: 0))
        // print(bold("Swiftris"), terminator: "")
    }

    // makeRaw sets the terminal to raw mode. This disables canonical mode, echo, signals, and extended input processing.
    // It also sets the character size to 8 bits and disables software flow control.
    // The changes are reverted when the terminal instance is deallocated or when restore is called manually.
    func makeRaw() throws {
        guard isatty(fd) != 0 else {
            Swift.print("failed to get terminal")
            throw TerminalError.get
        }

        let pio = originalTerimos()
        // get the original terminal settings
        guard tcgetattr(fd, pio) >= 0 else  {
            Swift.print("failed to get terminal settings")
            throw TerminalError.get
        }

        var copy = pio.pointee                                // copy the original settings to a new termios struct
        copy.c_iflag &= ~UInt(IXON | ICRNL | ISTRIP | BRKINT) // disable software flow control
        copy.c_oflag &= ~UInt(OPOST)                          // disable output processing
        copy.c_cflag &= ~UInt(CS8)                            // set character size to 8 bits
        copy.c_lflag &= ~UInt(ICANON | ECHO | ISIG | IEXTEN)  // disable canonical mode, echo, signals, and extended input processing

        guard tcsetattr(fd, TCSAFLUSH, &copy) >= 0 else {
            Swift.print("failed to set terminal to raw mode")
            throw TerminalError.makeRaw
        }
        tcflush(fd, TCIOFLUSH)
    }

    func restore() throws {
        guard tcsetattr(fd, TCSAFLUSH, originalTerimos()) >= 0 else {
            Swift.print("failed to restore terminal settings")
            throw TerminalError.restore
        }
    }

    func print(_ items: Any..., separator: String = " ", terminator: String = "\n\r") {
        let text = items.map { "\($0)" }.joined(separator: separator) + terminator
        Darwin.write(fd, text, text.utf8.count)
    }

    func debug(_ items: Any..., separator: String = " ", terminator: String = "\n\r") {
        if DEBUG {
            print("DEBUG:", terminator: " ")
            print(items, separator: separator, terminator: terminator)
        }
    }

    func goto(x: Int16, y: Int16) { print("\(Esc)[\(x);\(y)H") }

    func drawChar(x: Int16, y: Int16, char: Character) {
        goto(x: x, y: y)
        print(char, terminator: "")
    }

    // getch reads a single byte from the terminal input in non-blocking mode.
    func getch(timeout: DispatchTimeInterval = .never) -> Int8 {
        var c: Int8 = 0
        if timeout == .never {
            Darwin.read(fd, &c, 1)
            return c
        }

        let end = DispatchTime.now() + timeout
        let flags = fcntl(self.fd, F_GETFL, 0)

        while DispatchTime.now() < end {
            _ = fcntl(self.fd, F_SETFL, flags | O_NONBLOCK)
            let bytesRead = Darwin.read(self.fd, &c, 1)
            _ = fcntl(self.fd, F_SETFL, flags)

            if bytesRead == 1 {
                return c
            } else {
                // sleep for a bit to avoid busy waiting
                usleep(1000)
            }
        }

        return -1
    }

    func readKey() -> Key? {
        let c = getch()
        switch c {
        case 127: return .backspace
        case 10: return .enter
        case 13: return .return
        case 32: return .space
        case 27:
            let c2 = getch(timeout: .milliseconds(10))
            let c3 = getch(timeout: .milliseconds(10))
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
        case -1: return nil
        default:
            return .fromChar(c)
        }
    }
}
