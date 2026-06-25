import SwiftUI

/// Main container view — weight display + controls + device picker.
struct ContentView: View {
    @State private var viewModel = ScaleViewModel()
    @State private var showDevicePicker = false

    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar: connection status + battery + device picker
                headerBar

                Spacer()

                // Weight display
                WeightDisplayView(viewModel: viewModel)

                Spacer()

                // Brew timer
                BrewTimerView(viewModel: viewModel)

                Spacer()

                // Control buttons
                ControlBarView(viewModel: viewModel, showDevicePicker: $showDevicePicker)
                    .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showDevicePicker) {
            DeviceDiscoveryView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.startScanning()
        }
    }

    // MARK: - Header Bar

    private var headerBar: some View {
        HStack {
            // Connection status pill
            connectionStatusPill

            Spacer()

            // Battery indicator
            if viewModel.connectionState == .connected("") || viewModel.batteryPercent > 0 {
                batteryIndicator
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var connectionStatusPill: some View {
        Button {
            showDevicePicker = true
        } label: {
            HStack(spacing: 6) {
                Circle()
                    .fill(connectionColor)
                    .frame(width: 8, height: 8)

                Text(connectionLabel)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var batteryIndicator: some View {
        HStack(spacing: 2) {
            Image(systemName: viewModel.batteryIcon)
                .foregroundStyle(batteryColor)
            Text("\(viewModel.batteryPercent)%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Helpers

    private var connectionColor: Color {
        switch viewModel.connectionState {
        case .connected:    return .green
        case .connecting:   return .orange
        case .scanning:     return .blue
        case .failed:       return .red
        case .disconnected: return .gray
        }
    }

    private var connectionLabel: String {
        switch viewModel.connectionState {
        case .disconnected:      return "Not Connected"
        case .scanning:          return "Scanning…"
        case .connecting(let n): return "Connecting to \(n)"
        case .connected(let n):  return n
        case .failed(let e):     return e
        }
    }

    private var batteryColor: Color {
        viewModel.batteryPercent <= 10 ? .red : .secondary
    }
}
