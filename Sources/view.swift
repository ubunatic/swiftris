class View {
    var next: View?
    var input: String?

    var console:[String] = []

    init(_ next: View? = nil) {
        self.next = next
    }

    func show() -> View? {
        render()
        while read() {
            render()
        }
        return next
    }

    // print captures the print() output of a view and displays it under the main screen
    func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        // append to console
        console.append(items.map { "\($0)" }.joined(separator: separator))
        console.append(terminator)
        while console.count > 20 { console.removeFirst() }
        render()
        renderConsole()
    }

    // plot plots the lines of the screen
    func plot(_ lines:String..., clear:Bool = true, partial:Bool = false) {
        if clear {
            // clear terminal screen
            Swift.print("\u{001B}[2J")
        }
        for line in lines {
            Swift.print(line)
        }
        if partial {
            return
        }
        renderConsole()
    }

    func renderConsole() {
        for line in console {
            Swift.print(line, terminator: "")
        }
    }

    func render() {
        print("Empty View")
        print("")
        print("[Q]uit")
        print("")
    }

    func readKey() -> String {
        if let val = readLine(strippingNewline: true) {
            return val
        }
        return ""
    }

    // This default read function will read and store the input and return true
    // to continue reading, unless the input is "Q" or "q".
    func read() -> Bool {
        input = readKey()
        switch input {
        case "Q", "q":
            return false
        default:
            return true
        }
    }
}