import SwiftUI

extension EnvironmentValues {
    @Entry var numberSlotLabels: [String: Character] = [:]
}

struct ResultNumberHint: View {
    @Environment(\.numberSlotLabels) private var labels
    @Environment(\.metrics) private var metrics
    @Environment(PaletteState.self) private var palette
    private let key: String

    init<ID: Hashable>(id: ID) {
        key = String(reflecting: id)
    }

    var body: some View {
        if palette.commandHeld, !palette.menuOpen, let digit = labels[key] {
            HStack(spacing: metrics.spacing.xxs) {
                KeyCapChip(text: "⌘", style: .outline)
                KeyCapChip(text: String(digit), style: .outline)
            }
            .allowsHitTesting(false)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(verbatim: "⌘\(digit)"))
        }
    }
}
