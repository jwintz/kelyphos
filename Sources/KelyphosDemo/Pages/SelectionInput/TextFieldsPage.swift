// TextFieldsPage.swift - TextField/TextEditor

import SwiftUI

struct TextFieldsPage: View {
    @State private var name = ""
    @State private var email = ""
    @State private var notes = "Enter notes here..."
    @State private var password = ""

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("text-fields")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "TextField Styles") {
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("Default", text: $name)
                        TextField("Rounded Border", text: $email)
                            .textFieldStyle(.roundedBorder)
                        TextField("Plain", text: $name)
                            .textFieldStyle(.plain)
                    }
                }

                GlassSection(title: "Secure Field") {
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 250)
                }

                GlassSection(title: "TextEditor") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .scrollContentBackground(.hidden)
                        .font(.system(size: 12))
                }

                GlassSection(title: "Labeled Content") {
                    Form {
                        LabeledContent("Name") {
                            TextField("Enter name", text: $name)
                                .textFieldStyle(.roundedBorder)
                        }
                        LabeledContent("Email") {
                            TextField("Enter email", text: $email)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .formStyle(.grouped)
                }
            }
        }
    }
}
