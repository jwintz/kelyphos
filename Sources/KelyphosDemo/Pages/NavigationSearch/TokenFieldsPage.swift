// TokenFieldsPage.swift - NSTokenField wrapper

import SwiftUI
import AppKit

struct TokenFieldsPage: View {
    @State private var tokens: [String] = ["Swift", "SwiftUI", "macOS"]

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("token-fields")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Token Field") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Token fields allow users to enter and display discrete tokens (tags). They are a macOS-specific component via NSTokenField.")
                            .foregroundStyle(.secondary)

                        TokenFieldRepresentable(tokens: $tokens)
                            .frame(height: 28)
                    }
                }

                GlassSection(title: "Current Tokens") {
                    HStack {
                        ForEach(tokens, id: \.self) { token in
                            Text(token)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.blue.opacity(0.1), in: Capsule())
                        }
                    }
                }
            }
        }
    }
}

private struct TokenFieldRepresentable: NSViewRepresentable {
    @Binding var tokens: [String]

    func makeNSView(context: Context) -> NSTokenField {
        let field = NSTokenField()
        field.objectValue = tokens
        field.delegate = context.coordinator
        return field
    }

    func updateNSView(_ nsView: NSTokenField, context: Context) {
        nsView.objectValue = tokens
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(tokens: $tokens)
    }

    final class Coordinator: NSObject, NSTokenFieldDelegate {
        @Binding var tokens: [String]

        init(tokens: Binding<[String]>) {
            self._tokens = tokens
        }

        func tokenField(_ tokenField: NSTokenField, shouldAdd tokens: [Any], at index: Int) -> [Any] {
            tokens
        }

        func controlTextDidEndEditing(_ obj: Notification) {
            if let field = obj.object as? NSTokenField,
               let values = field.objectValue as? [String] {
                tokens = values
            }
        }
    }
}
