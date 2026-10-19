import Foundation

/// The same mapping labels visible results and resolves their physical number keys.
struct NumberSlots {
    var firstRow = 0
    var count = 10
    static let digits: [Character] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

    /// ANSI number-row key codes in visual order 1…9,0. This is layout-independent.
    private static let numberRowKeyCodes: [UInt16] = [18, 19, 20, 21, 23, 22, 26, 28, 25, 29]

    /// The favorite a digit launches, or nil when that key is not a slot.
    static func index(for digit: Character) -> Int? { digits.firstIndex(of: digit) }

    /// The favorite a physical number-row key launches, or nil when that key is not a slot.
    static func index(forKeyCode keyCode: UInt16) -> Int? {
        numberRowKeyCodes.firstIndex(of: keyCode)
    }

    static func digit(at index: Int) -> Character? {
        digits.indices.contains(index) ? digits[index] : nil
    }

    func selection(at slot: Int, rowCount: Int) -> Int? {
        guard firstRow >= 0, slot >= 0, slot < min(count, Self.digits.count),
            firstRow < rowCount, slot < rowCount - firstRow
        else { return nil }
        return firstRow + slot
    }

    func digit(forRow row: Int) -> Character? {
        guard firstRow >= 0, row >= firstRow, row - firstRow < count else { return nil }
        return Self.digit(at: row - firstRow)
    }
}
