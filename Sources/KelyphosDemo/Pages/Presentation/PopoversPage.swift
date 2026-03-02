// PopoversPage.swift - .popover modifier

import SwiftUI

struct PopoversPage: View {
    @State private var showPopover = false
    @State private var showArrowPopover = false

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("popovers")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Basic Popover") {
                    Button("Show Popover") {
                        showPopover.toggle()
                    }
                    .popover(isPresented: $showPopover) {
                        VStack(spacing: 12) {
                            Text("Popover Content")
                                .font(.headline)
                            Text("Popovers display additional content anchored to a source view.")
                                .foregroundStyle(.secondary)
                                .frame(width: 200)
                        }
                        .padding()
                    }
                }

                GlassSection(title: "Popover with Arrow Edge") {
                    Button("Show (Arrow Bottom)") {
                        showArrowPopover.toggle()
                    }
                    .popover(isPresented: $showArrowPopover, arrowEdge: .bottom) {
                        VStack(spacing: 8) {
                            Label("Settings", systemImage: "gearshape")
                            Toggle("Enable Feature", isOn: .constant(true))
                        }
                        .padding()
                        .frame(width: 200)
                    }
                }
            }
        }
    }
}
