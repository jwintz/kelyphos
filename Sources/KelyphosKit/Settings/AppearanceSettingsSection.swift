// AppearanceSettingsSection.swift - Appearance/opacity/vibrancy/presets controls

import SwiftUI

/// A Form section for controlling window appearance, opacity, vibrancy, and presets.
public struct AppearanceSettingsSection: View {
    @Bindable var state: KelyphosShellState

    private var presetBinding: Binding<AppearancePreset?> {
        Binding(
            get: { AppearancePreset.detect(from: state) },
            set: { newValue in
                guard let preset = newValue else { return }
                preset.apply(to: state)
            }
        )
    }

    public init(state: KelyphosShellState) {
        self.state = state
    }

    public var body: some View {
        Section("Window") {
            LabeledContent("Appearance") {
                Picker("Appearance", selection: $state.windowAppearance) {
                    Label("Auto", systemImage: "circle.lefthalf.filled").tag("auto")
                    Label("Light", systemImage: "sun.max.fill").tag("light")
                    Label("Dark", systemImage: "moon.fill").tag("dark")
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            LabeledContent("Opacity") {
                HStack(spacing: 8) {
                    Slider(value: $state.backgroundAlpha, in: 0...1)
                    Text("\(Int(state.backgroundAlpha * 100))%")
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                        .frame(width: 35, alignment: .trailing)
                }
            }

            LabeledContent("Vibrancy") {
                Picker("Material", selection: $state.vibrancyMaterial) {
                    ForEach(VibrancyMaterial.allCases, id: \.self) { material in
                        Text(material.rawValue.capitalized).tag(material)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }

        Section("Presets") {
            LabeledContent("Presets") {
                Picker("Presets", selection: presetBinding) {
                    Text("Clear").tag(Optional(AppearancePreset.clear))
                    Text("Balanced").tag(Optional(AppearancePreset.balanced))
                    Text("Solid").tag(Optional(AppearancePreset.solid))
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
        }
        .onChange(of: state.windowAppearance) { _, _ in state.saveAppearance() }
        .onChange(of: state.backgroundAlpha)  { _, _ in state.saveAppearance() }
        .onChange(of: state.vibrancyMaterial) { _, _ in state.saveAppearance() }
    }
}
