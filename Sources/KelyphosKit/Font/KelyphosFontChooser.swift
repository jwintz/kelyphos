// KelyphosFontChooser.swift - Picker with preview and size

import SwiftUI

/// A font chooser with family picker, size control, and live preview.
public struct KelyphosFontChooser: View {
    @Binding var selectedFamily: KelyphosFontFamily
    @Binding var fontSize: CGFloat

    @State private var previewText: String = "The quick brown fox jumps over the lazy dog."

    public init(selectedFamily: Binding<KelyphosFontFamily>, fontSize: Binding<CGFloat>) {
        self._selectedFamily = selectedFamily
        self._fontSize = fontSize
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: KelyphosDesign.Spacing.standard) {
            // Family picker
            HStack {
                Text("Font")
                    .font(.system(size: KelyphosDesign.FontSize.body))
                Spacer()
                Picker("Family", selection: $selectedFamily) {
                    ForEach(KelyphosFontStack.all) { family in
                        Text(family.displayName).tag(family)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 200)
            }

            // Size control
            HStack {
                Text("Size")
                    .font(.system(size: KelyphosDesign.FontSize.body))
                Spacer()
                HStack(spacing: 4) {
                    Button {
                        if fontSize > 8 { fontSize -= 1 }
                    } label: {
                        Image(systemName: "minus")
                    }
                    .buttonStyle(.bordered)

                    Text("\(Int(fontSize)) pt")
                        .font(.system(size: KelyphosDesign.FontSize.body).monospacedDigit())
                        .frame(width: 50, alignment: .center)

                    Button {
                        if fontSize < 72 { fontSize += 1 }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.bordered)

                    Slider(value: $fontSize, in: 8...72, step: 1)
                        .frame(maxWidth: 120)
                }
            }

            // Preview
            GroupBox("Preview") {
                TextEditor(text: $previewText)
                    .font(selectedFamily.font(size: fontSize))
                    .frame(height: 80)
                    .scrollContentBackground(.hidden)
            }
        }
        .padding()
    }
}
