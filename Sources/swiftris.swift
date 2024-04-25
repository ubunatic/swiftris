// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

func esc(_ string: String, _ code: String = "0;0m") -> String { return "\u{001B}[\(code)\(string)\u{001B}[0m" }
func bold(_ string: String) -> String { return esc(string, "1m") }
func bold_white(_ string: String) -> String { return esc(string, "1;37m") }

@main
struct swiftris: ParsableCommand {
    mutating func run() throws {
        Screen(main: Title()).show()
    }
}

class Screen {
    var main:View
    var current:View

    init(main:View) {
        self.main = main
        self.current = main
    }

    func show() {
        while true {
            if let next = current.show() {
                current = next
            }
            if current === main {
                // main screen exited without next -> quit
                return
            }
        }
    }
}

class Title: View {
    override func render() {
         let title = bold_white("SWIFTRIS!")
        plot(
            "🟨🟨           🟪  ",
            "  🟨 \(title) 🟪  ",
            "  🟨           🟪🟪",
            "Welcome to Swiftris!",
            "",
            "[P]lay",
            "[H]elp",
            "[Q]uit",
            ""
        )
    }

    override func read() -> Bool {
        let ok = super.read()
        switch input {
        case "P", "p":
            print("Play")
        case "H", "h":
            print("Help")
        case "Q", "q":
            return false
        default:
            return ok
        }
        return ok
    }
}

