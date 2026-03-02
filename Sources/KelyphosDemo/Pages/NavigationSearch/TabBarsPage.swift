// TabBarsPage.swift - TabView styles

import SwiftUI

struct TabBarsPage: View {
    @State private var selectedTab = 0

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("tab-bars")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "TabView (Default)") {
                    TabView(selection: $selectedTab) {
                        Text("First Tab Content")
                            .tabItem { Label("First", systemImage: "1.circle") }
                            .tag(0)
                        Text("Second Tab Content")
                            .tabItem { Label("Second", systemImage: "2.circle") }
                            .tag(1)
                        Text("Third Tab Content")
                            .tabItem { Label("Third", systemImage: "3.circle") }
                            .tag(2)
                    }
                    .frame(height: 120)
                }

                GlassSection(title: "About Tab Views") {
                    Text("Tab bars let people navigate between different areas of an app. SwiftUI provides TabView which adapts to each platform. On macOS, tabs appear at the top of the window.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
