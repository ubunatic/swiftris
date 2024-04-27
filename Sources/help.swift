import Foundation

class Help: View {
    let title = bold_white("SWIFTRIS!")
    let content: [String]

    override init(_ next: View? = nil) {
        self.content = [
            "🟨🟨           🟪  ",
            "  🟨 \(title) 🟪  ",
            "  🟨           🟪🟪",
            "Help",
            "",
            "Use the arrow keys to move the piece.",
            "Use the space bar to rotate the piece.",
            "Press 'Q' to quit.",
            "",
            "[B]ack",
            ""
        ]
        super.init(next)
    }

    override func render(_ t: Terminal) {
        plot(content)
        super.render(t)
    }

    override func read(_ t:Terminal) -> Bool {
        let ok = super.read(t)
        switch key {
        case .B, .b:
            return false
        default:
            return ok
        }
    }
}