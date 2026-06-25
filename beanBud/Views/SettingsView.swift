import SwiftUI

/// Settings screen — unit selection and any future preferences.
struct SettingsView: View {
    @Bindable var viewModel: ScaleViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Weight Unit") {
                    Picker("Unit", selection: $viewModel.displayUnit) {
                        ForEach(WeightUnit.allCases) { unit in
                            Text(unit.symbol)
                                .tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    HStack {
                        Text("Battery")
                        Spacer()
                        Text("\(viewModel.batteryPercent)%")
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(versionString)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }

    private var versionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
