import Foundation
import ArgumentParser

class Title: View {
    let title = bold_white("SWIFTRIS")
    let header: [String]
    let footer: [String]
    var menu: [String]
    var pos = 0

    // connected views
    var game: Game!
    var help: Help!

    init() {
        self.header = [
            "🟨🟨　　　　　　🟪",
            "　🟨　\(title)　🟪",
            "　🟨　　　　　　🟪🟪",
            "Welcome to Swiftris!",
            "",
        ]
        self.menu = [
            "[P]lay",
            "[H]elp",
            "[Q]uit",
        ]
        self.footer = [""]
        super.init(nil)

        self.game = Game(self)
        self.help = Help(self)
    }

    override func render(_ t: Terminal) {
        let selection = menu.map { $0 == menu[pos] ? bold_white($0) : $0 }
        plot(header + selection + footer)
        super.render(t)
    }

    override func handleKey(_ k:Key) -> View? {
        let next = super.handleKey(k)
        switch k {
        case .P, .p: return game
        case .H, .h: return help
        case .Q, .q: return Exit()
        case .enter, .space, .return:
            switch pos {
            case 0:  return game
            case 1:  return help
            case 2:  return Exit()
            default: break
            }
        case .up:
            pos = (pos + menu.count - 1) % menu.count
        case .down:
            pos = (pos + 1) % menu.count
        default:
            break
        }
        return next
    }
}
