import Foundation

class View {
    var previous: View?
    var input: String?
    var consoleLimit = 7

    var screen:[String] = [
        "Empty View",
        "",
        "[Q]uit",
        ""
    ]

    var console:[String] = []

    init(_ previous: View? = nil) {
        self.previous = previous
        self.console = Array(repeating: "", count: consoleLimit)
    }

    // show will render the view and read input until the read function returns false.
    // This the default behavior for a view and can be overridden if needed.
    // Also see: render, read
    public func show(_ t:Terminal) -> View? {
        render(t)
        while true {
            if let k = t.readKey() {
                if let next = handleKey(k) {
                    next.print("key:", k, "next:", next)
                    return next
                }
                self.print("key:", k)
            }
            render(t)
        }
    }

    // print captures the print() output of a view and displays it under the main screen.
    public func print(_ items: Any..., separator: String = " ", terminator: String = "\n\r") {
        // append to console
        console.append(items.map { "\($0)" }.joined(separator: separator) + terminator)
        while console.count > consoleLimit { console.removeFirst() }
    }

    // plot adds lines to the screen buffer.
    public func plot(_ lines:[String], clear:Bool = true) {
        if clear {
            // clear terminal screen
            screen.removeAll()
            screen.append(ClearString + GotoTop)
        }
        for line in lines {
            screen.append(line)
        }
    }

    // The default render function prints the screen buffer and console buffer to the terminal.
    // This method can be overridden to provide custom rendering.
    public func render(_ t:Terminal) {
        for line in screen {
            t.print(line)
        }
        for line in console {
            t.print(line, terminator: "")
        }
        for line in t.log {
            t.print(line, terminator: "\n\r")
        }
        t.decorate()
    }

    // It returns Exit view if the key is "Q" or "q".
    // Otherwise it returns nil.
    // This method can be overridden to provide custom key handling logic.
    public func handleKey(_ k: Key) -> View? {
        switch k {
        case .Q, .q:
            return Exit()
        case .B, .b, .esc:
            print("back, key:", k)
            return previous
        case .enter, .space, .return:
            print("enter, key:", k)
            return previous
        default:
            break
        }
        return nil
    }
}
