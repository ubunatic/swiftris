import Foundation
import ArgumentParser
import Darwin

@main
struct swiftris: ParsableCommand {
    func run() throws {
        let t = Terminal()
        try! t.makeRaw()
        Screen(view: Title()).show(t)
    }
}

// Screen manages Views and transitions between them.
class Screen {
    var view:View

    init(view:View) {
        self.view = view
    }

    func show(_ t:Terminal) {
        while true {
            guard let next = view.show(t) else { return }
            view = next
            if view is Exit {
                view.render(t)
                sleep(1)
                return
            }
        }
    }
}

// Exit is a View that displays a goodbye message.
class Exit: View {
    override func render(_ t: Terminal) {
        plot(["Goodbye!"])
        super.render(t)
    }
}
