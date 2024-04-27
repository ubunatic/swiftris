import Foundation

class View {
    public var next: View?
    public var input: String?
    public var key: Key?

    var screen:[String] = [
        "Empty View",
        "",
        "[Q]uit",
        ""
    ]

    var console:[String] = []

    init(_ next: View? = nil) {
        self.next = next
    }

    // show will render the view and read input until the read function returns false.
    // This the default behavior for a view and can be overridden if needed.
    // Also see: render, read
    public func show(_ t:Terminal) -> View? {
        render(t)
        while read(t) {
            render(t)
        }
        return next
    }

    // print captures the print() output of a view and displays it under the main screen.
    public func print(_ items: Any..., separator: String = " ", terminator: String = "\n\r") {
        // append to console
        console.append(items.map { "\($0)" }.joined(separator: separator))
        console.append(terminator)
        while console.count > 20 { console.removeFirst() }
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
        t.decorate()
    }

    public func readKey() -> String {
        // read single key from terminal without waiting for return key
        if let val = readLine(strippingNewline: true) {
            return val
        }
        return ""
    }

    // The default read function reads and stores terminal input.
    // It returns false if the input is "Q" or "q".
    // Otherwise it returns true.
    public func read(_ t: Terminal) -> Bool {
        key = t.readKey()
        switch key {
        case .Q, .q:
            return false
        default:
            return true
        }
    }
}
