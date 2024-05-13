import Foundation

class Help: View {
    let content: [String]
    let title = bold_white("SWIFTRIS")

    override init(_ next: View? = nil) {
        self.content = [
            "🟨🟨　　　　　　🟪",
            "　🟨　\(title)　🟪",
            "　🟨　　　　　　🟪🟪",
            "Help",
            "",
            "   \(invert(bold_white("[↑]")))     rotate piece",
            "\(invert(bold_white("[←][↓][→]")))  move piece",
            "",
            "\(invert(bold_white("[ space ]")))  drop piece",
            "",
            "[Q]uit",
            "[B]ack",
            ""
        ]
        super.init(next)
    }

    override func render(_ t: Terminal) {
        plot(content)
        super.render(t)
    }
}