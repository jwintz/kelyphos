// SheetsPage.swift - .sheet modifier

import SwiftUI

struct SheetsPage: View {
    @State private var showSheet = false
    @State private var showFullScreen = false

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("sheets")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Sheet") {
                    VStack(alignment: .leading, spacing: 12) {
                        Button("Present Sheet") {
                            showSheet = true
                        }
                        .sheet(isPresented: $showSheet) {
                            VStack(spacing: 16) {
                                Text("Sheet Content")
                                    .font(.title2)
                                Text("Sheets slide up from the bottom on iOS and appear as a centered modal on macOS.")
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                Button("Dismiss") { showSheet = false }
                                    .buttonStyle(.borderedProminent)
                            }
                            .padding(30)
                            .frame(minWidth: 300, minHeight: 200)
                        }
                    }
                }

                GlassSection(title: "About Sheets") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sheets are modal presentations that require user interaction before returning to the parent view.")
                            .foregroundStyle(.secondary)

                        Text("Modifiers:")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 4) {
                            Label(".sheet — Standard sheet presentation", systemImage: "rectangle.bottomthird.inset.filled")
                            Label(".fullScreenCover — Full screen (iOS)", systemImage: "rectangle.fill")
                            Label(".interactiveDismissDisabled — Prevent swipe dismiss", systemImage: "hand.raised")
                            Label(".presentationDetents — Sheet height (iOS 16+)", systemImage: "arrow.up.and.down")
                        }
                        .font(.system(size: 12))
                    }
                }
            }
        }
    }
}
