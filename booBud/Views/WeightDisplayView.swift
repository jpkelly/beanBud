import SwiftUI

/// Large weight display with unit label. The decimal point turns green when stable.
struct WeightDisplayView: View {
    @Bindable var viewModel: ScaleViewModel

    var body: some View {
        HStack(spacing: 0) {
            Spacer()

            HStack(spacing: 0) {
                Text(integerPart)
                    .font(.system(size: 80, weight: .thin, design: .default))
                    .monospacedDigit()
                Text(".")
                    .font(.system(size: 80, weight: .thin, design: .default))
                    .foregroundStyle(decimalColor)
                Text(fractionalPart)
                    .font(.system(size: 80, weight: .thin, design: .default))
                    .monospacedDigit()
            }
            .overlay(alignment: Alignment(horizontal: .trailing, vertical: .lastTextBaseline)) {
                Text(" \(viewModel.weightUnitSymbol)")
                    .font(.system(size: 36, weight: .medium, design: .default))
                    .foregroundStyle(.secondary)
                    .alignmentGuide(.trailing) { d in d[.leading] }
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Helpers

    /// Splits "250.0" → integer "250", fractional "0"
    private var integerPart: String {
        let parts = viewModel.displayWeight.split(separator: ".")
        return String(parts.first ?? "0")
    }

    private var fractionalPart: String {
        let parts = viewModel.displayWeight.split(separator: ".")
        return parts.count > 1 ? String(parts[1]) : "0"
    }

    private var decimalColor: Color {
        guard let reading = viewModel.currentReading else { return .secondary }
        return reading.isStable ? .green : .orange
    }
}
