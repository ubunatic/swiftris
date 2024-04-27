// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser

@main
struct swiftris: ParsableCommand {
    mutating func run() throws {
        let t = Terminal()
        do {
            try t.makeRaw()
            Screen(main: Title()).show(t)
            try t.restore()
        } catch {
            try t.restore()
            throw error
        }
    }
}

class Exit: View {
    override func render(_ t: Terminal) {
        plot(["Goodbye!"])
        super.render(t)
    }
}

class Screen {
    var main:View
    var current:View

    init(main:View) {
        self.main = main
        self.current = main
    }

    func show(_ t:Terminal) {
        while true {
            guard let next = current.show(t) else { return }
            current = next
            // if current is Exit, return
            if current is Exit {
                current.render(t)
                sleep(1)
                return
            }
        }
    }
}

class Title: View {
    let title = bold_white("SWIFTRIS!")
    let content: [String]

    init() {
        self.content = [
            "🟨🟨           🟪  ",
            "  🟨 \(title) 🟪  ",
            "  🟨           🟪🟪",
            "Welcome to Swiftris!",
            "",
            "[P]lay",
            "[H]elp",
            "[Q]uit",
            ""
        ]
        super.init(nil)
    }

    override func render(_ t: Terminal) {
        plot(content)
        super.render(t)
    }

    override func read(_ t:Terminal) -> Bool {
        let ok = super.read(t)
        switch key {
        case .P, .p:
            next = Game(self)
            return false
        case .H, .h:
            next = Help(self)
            return false
        case .Q, .q:
            next = Exit()
            return false
        default:
            return ok
        }
    }
}

