import SwiftUI

/// Bottom control bar — Tare, Unit toggle, and Tare+Timer combo.
struct ControlBarView: View {
    @Bindable var viewModel: ScaleViewModel
    @Binding var showDevicePicker: Bool

    var body: some View {
        HStack(spacing: 32) {
            // Tare button
            ControlButton(
                icon: "scalemass",
                label: "Tare",
                action: { viewModel.tare() }
            )

            // Tare + Start Timer (primary brew action)
            ControlButton(
                icon: "timer",
                label: "Brew",
                action: { viewModel.tareAndStartTimer() },
                isPrimary: true
            )

            // Unit toggle
            ControlButton(
                icon: "arrow.triangle.2.circlepath",
                label: viewModel.displayUnit.symbol,
                action: { viewModel.toggleUnit() }
            )
        }
    }
}

// MARK: - Control Button

private struct ControlButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    var isPrimary: Bool = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption)
            }
            .frame(width: 72, height: 64)
        }
        .buttonStyle(.borderedProminent)
        .tint(isPrimary ? .orange : .secondary)
    }
}
