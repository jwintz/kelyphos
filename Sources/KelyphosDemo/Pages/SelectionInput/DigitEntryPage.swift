// DigitEntryPage.swift - Formatted TextField

import SwiftUI

struct DigitEntryPage: View {
    @State private var amount: Double = 0
    @State private var percentage: Double = 50
    @State private var integer: Int = 42

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("digit-entry")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Formatted Number Fields") {
                    Form {
                        LabeledContent("Currency") {
                            TextField("Amount", value: $amount, format: .currency(code: "USD"))
                                .textFieldStyle(.roundedBorder)
                        }
                        LabeledContent("Percentage") {
                            TextField("Percent", value: $percentage, format: .percent)
                                .textFieldStyle(.roundedBorder)
                        }
                        LabeledContent("Integer") {
                            TextField("Number", value: $integer, format: .number)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .formStyle(.grouped)
                }

                GlassSection(title: "About Digit Entry") {
                    Text("On iOS, Digit Entry Views provide a specialized interface for entering numeric values like verification codes. On macOS, formatted TextField with number formatters provides similar functionality.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
