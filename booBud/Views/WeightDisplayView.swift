import SwiftUI

/// Large weight display with unit label.
struct WeightDisplayView: View {
    @Bindable var viewModel: ScaleViewModel

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                Spacer()
                Text(viewModel.displayWeight)
                    .font(.system(size: 80, weight: .thin, design: .default))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .overlay(alignment: Alignment(horizontal: .trailing, vertical: .lastTextBaseline)) {
                        Text(" \(viewModel.weightUnitSymbol)")
                            .font(.system(size: 36, weight: .medium, design: .default))
                            .foregroundStyle(.secondary)
                            .alignmentGuide(.trailing) { d in d[.leading] }
                    }
                Spacer()
            }

            // Stability indicator
            HStack(spacing: 6) {
                Circle()
                    .fill(viewModel.currentReading?.isStable == true ? Color.green : Color.orange)
                    .frame(width: 6, height: 6)
                Text(viewModel.currentReading?.isStable == true ? "Stable" : "Measuring")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 60, alignment: .leading)
            }
            .opacity(viewModel.currentReading == nil ? 0 : 1)
        }
        .padding(.horizontal)
        .padding(.top)
        .frame(maxWidth: .infinity)
    }
}
