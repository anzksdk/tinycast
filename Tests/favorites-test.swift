import Foundation

@main
struct FavoritesTest {
    static func main() {
        var failures = 0

        func check(_ description: String, _ condition: @autoclosure () -> Bool) {
            if condition() {
                print("PASS  \(description)")
            } else {
                print("FAIL  \(description)")
                failures += 1
            }
        }

        // Ten digit keys is the ceiling: there is no ⌘10, so the eleventh favorite gets no chord.
        check("ten slots", NumberSlots.digits.count == 10)
        check("no digit repeats", Set(NumberSlots.digits).count == NumberSlots.digits.count)

        check("⌘1 is the first favorite", NumberSlots.index(for: "1") == 0)
        check("⌘9 is the ninth", NumberSlots.index(for: "9") == 8)
        check("⌘0 is the tenth, not the first", NumberSlots.index(for: "0") == 9)
        check("a letter is not a slot", NumberSlots.index(for: "a") == nil)

        let numberRowKeyCodes: [UInt16] = [18, 19, 20, 21, 23, 22, 26, 28, 25, 29]
        for (index, keyCode) in numberRowKeyCodes.enumerated() {
            check(
                "physical number-row keycode \(keyCode) maps to slot \(index)",
                NumberSlots.index(forKeyCode: keyCode) == index)
        }
        check("unknown keycode is not a slot", NumberSlots.index(forKeyCode: 0) == nil)

        check("the first row shows 1", NumberSlots.digit(at: 0) == "1")
        check("the tenth row shows 0", NumberSlots.digit(at: 9) == "0")
        check("the eleventh row shows nothing", NumberSlots.digit(at: 10) == nil)
        check("a negative index shows nothing", NumberSlots.digit(at: -1) == nil)

        // The row overlay and the key handler must agree, or a row advertises another's chord.
        for index in NumberSlots.digits.indices {
            guard let digit = NumberSlots.digit(at: index) else {
                check("slot \(index) has a digit", false)
                continue
            }
            check("slot \(index) round-trips", NumberSlots.index(for: digit) == index)
        }

        let results = NumberSlots()
        check("second search result", results.selection(at: 1, rowCount: 7) == 1)
        check("tenth search result", results.selection(at: 9, rowCount: 20) == 9)
        check("empty list", results.selection(at: 0, rowCount: 0) == nil)
        check("missing second result", results.selection(at: 1, rowCount: 1) == nil)
        check("negative slot", results.selection(at: -1, rowCount: 20) == nil)
        check("no eleventh shortcut", results.selection(at: 10, rowCount: 20) == nil)
        let meeting = NumberSlots(firstRow: 1)
        check("meeting leaves first favorite on one", meeting.selection(at: 0, rowCount: 4) == 1)
        check("meeting has no hint", meeting.digit(forRow: 0) == nil)
        check("first favorite hint", meeting.digit(forRow: 1) == "1")
        let emoji = NumberSlots(count: 9)
        check("emoji nine still works", emoji.selection(at: 8, rowCount: 100) == 8)
        check("emoji zero stays zoom", emoji.selection(at: 9, rowCount: 100) == nil)
        check("emoji tenth has no hint", emoji.digit(forRow: 9) == nil)
        for mapping in [results, meeting, emoji] {
            for count in 0...24 {
                for slot in 0..<10 {
                    if let row = mapping.selection(at: slot, rowCount: count) {
                        check("result hint and activation agree", mapping.digit(forRow: row) == NumberSlots.digit(at: slot))
                    }
                }
            }
        }

        print(failures == 0 ? "\nALL PASSED" : "\n\(failures) failed")
        if failures > 0 { exit(1) }
    }
}
