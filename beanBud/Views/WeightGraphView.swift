import SwiftUI

/// Real-time weight vs time line chart for the brewing process.
struct WeightGraphView: View {
    let data: [(elapsed: Double, weight: Double)]
    let displayUnit: WeightUnit

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Y-axis label (max weight)
            if let maxW = maxWeight {
                Text(formatWeight(maxW))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 4)
            }

            GeometryReader { geometry in
                Path { path in
                    guard data.count > 1 else { return }
                    let w = geometry.size.width
                    let h = geometry.size.height
                    let maxT = maxTime
                    let minW = minWeight ?? 0
                    let rangeW = (maxWeight ?? 1) - minW
                    let rangeWClamped = max(rangeW, 0.1)

                    for (i, point) in data.enumerated() {
                        let x = w * (maxT > 0 ? point.elapsed / maxT : 0)
                        let y = h * (1 - (point.weight - minW) / rangeWClamped)
                        let pt = CGPoint(x: x, y: y)
                        if i == 0 {
                            path.move(to: pt)
                        } else {
                            path.addLine(to: pt)
                        }
                    }
                }
                .stroke(
                    LinearGradient(
                        colors: [.orange, .orange.opacity(0.6)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                )
            }

            // X-axis label (time)
            HStack {
                Text("0s")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(formatTime(maxTime))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)
        }
        .padding(8)
        .background(.ultraThinMaterial.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Helpers

    private var maxTime: Double {
        data.last?.elapsed ?? 0
    }

    private var maxWeight: Double? {
        data.map(\.weight).max()
    }

    private var minWeight: Double? {
        data.map(\.weight).min()
    }

    private func formatWeight(_ grams: Double) -> String {
        displayUnit.format(grams)
    }

    private func formatTime(_ seconds: Double) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return "\(m):\(String(format: "%02d", s))"
    }
}
