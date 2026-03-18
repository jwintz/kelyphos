// ThreeColumnDemoView.swift - Mail-like three-column layout showcase

import SwiftUI
import KelyphosKit

// MARK: - Mock Data

private struct MockMessage: Identifiable, Hashable {
    let id: Int
    let sender: String
    let subject: String
    let preview: String
    let date: String
    let isRead: Bool
    let body: String
}

private let mockMessages: [MockMessage] = [
    MockMessage(id: 1, sender: "Sarah Chen", subject: "Design review for v2.0", preview: "Hi team, I've attached the latest mockups for the redesign…", date: "10:32 AM", isRead: false, body: "Hi team,\n\nI've attached the latest mockups for the redesign. The main changes are:\n\n1. Updated navigation bar with Liquid Glass material\n2. New three-column layout for the inbox view\n3. Simplified compose sheet\n\nPlease review and share your feedback by Friday.\n\nBest,\nSarah"),
    MockMessage(id: 2, sender: "Build System", subject: "[CI] Build #4217 succeeded", preview: "All 342 tests passed. Coverage: 87.3%…", date: "9:15 AM", isRead: true, body: "Build #4217 completed successfully.\n\nResults:\n- 342 tests passed\n- 0 tests failed\n- Code coverage: 87.3%\n- Build time: 2m 34s\n\nCommit: abc1234 — \"Add command palette to KelyphosKit\""),
    MockMessage(id: 3, sender: "Alex Rivera", subject: "Meeting notes: Sprint planning", preview: "Here are the action items from today's sprint planning…", date: "Yesterday", isRead: true, body: "Hey everyone,\n\nHere are the action items from today's sprint planning:\n\n- @Sarah: Finalize the three-column layout API\n- @Alex: Write integration tests for the command palette\n- @Jordan: Update the documentation site\n\nNext sync: Thursday 2pm.\n\nCheers,\nAlex"),
    MockMessage(id: 4, sender: "Jordan Park", subject: "Re: API design question", preview: "I think using a generic Content parameter is the right call…", date: "Yesterday", isRead: false, body: "I think using a generic Content parameter is the right call. It keeps the API backward-compatible while enabling the three-column layout.\n\nThe key insight is that `Content == EmptyView` for the existing two-column case, so no existing call sites need to change.\n\nShould we also add a `contentColumnWidth` parameter?"),
    MockMessage(id: 5, sender: "App Store Connect", subject: "Your app has been approved", preview: "KelyphosDemo version 1.0 (build 42) has been approved…", date: "Mar 15", isRead: true, body: "Dear Developer,\n\nKelyphosDemo version 1.0 (build 42) has been approved and is now available on the App Store.\n\nThank you for submitting your app.\n\nBest regards,\nThe App Review Team"),
    MockMessage(id: 6, sender: "GitHub", subject: "[kelyphos] PR #73 merged", preview: "Feature: Command Palette framework has been merged into main…", date: "Mar 14", isRead: true, body: "Pull request #73 \"Feature: Command Palette framework\" has been merged into main by @jwintz.\n\n+487 −12 across 8 files\n\nNew files:\n- CommandPalette/KelyphosCommandItem.swift\n- CommandPalette/KelyphosFuzzyMatcher.swift\n- CommandPalette/KelyphosCommandPaletteView.swift\n- CommandPalette/KelyphosCommandPaletteRegistry.swift"),
    MockMessage(id: 7, sender: "Morgan Lee", subject: "Coffee chat tomorrow?", preview: "Hey! Are you free for a quick coffee chat tomorrow around 3?", date: "Mar 13", isRead: true, body: "Hey!\n\nAre you free for a quick coffee chat tomorrow around 3? I'd love to catch up and hear about the KelyphosKit work.\n\nThe new café on 4th street has great espresso.\n\nLet me know!\nMorgan"),
]

// MARK: - Three-Column Demo Scene

struct ThreeColumnDemoSceneView: View {
    @State private var shellState = KelyphosShellState(
        persistencePrefix: "kelyphos.demo.threecolumn",
        panelPrefix: "kelyphos.demo.threecolumn"
    )
    @State private var selectedMessage: MockMessage?

    var body: some View {
        KelyphosShellView(
            state: shellState,
            configuration: KelyphosShellConfiguration(
                navigatorTabs: MailboxNavigatorTab.allCases.map { $0 },
                inspectorTabs: MessageInspectorTab.allCases.map { $0 },
                utilityTabs: DemoUtilityTab.allCases.map { $0 },
                scrollable: false,
                content: {
                    MessageListView(selection: $selectedMessage)
                },
                detail: {
                    MessageDetailView(message: selectedMessage)
                }
            )
        )
        .onAppear {
            shellState.title = "Kelyphos Mail"
            shellState.subtitle = "Inbox"
        }
    }
}

// MARK: - Navigator Tabs (Mailboxes)

private enum MailboxNavigatorTab: String, KelyphosPanel, CaseIterable {
    case mailboxes
    case favorites

    nonisolated var id: String { rawValue }
    nonisolated var title: String {
        switch self {
        case .mailboxes: "Mailboxes"
        case .favorites: "Favorites"
        }
    }
    nonisolated var systemImage: String {
        switch self {
        case .mailboxes: "tray.2"
        case .favorites: "star"
        }
    }

    var body: some View {
        switch self {
        case .mailboxes: MailboxListView()
        case .favorites: FavoritesListView()
        }
    }
}

private struct MailboxListView: View {
    var body: some View {
        List {
            Section("Favorites") {
                Label("Inbox", systemImage: "tray")
                    .badge(2)
                Label("Flagged", systemImage: "flag")
                Label("Sent", systemImage: "paperplane")
            }
            Section("Mailboxes") {
                Label("Drafts", systemImage: "doc")
                Label("Archive", systemImage: "archivebox")
                Label("Junk", systemImage: "xmark.bin")
                Label("Trash", systemImage: "trash")
            }
        }
        .listStyle(.sidebar)
    }
}

private struct FavoritesListView: View {
    var body: some View {
        List {
            Label("Inbox", systemImage: "tray")
                .badge(2)
            Label("Flagged", systemImage: "flag")
            Label("Sent", systemImage: "paperplane")
        }
        .listStyle(.sidebar)
    }
}

// MARK: - Inspector Tabs

private enum MessageInspectorTab: String, KelyphosPanel, CaseIterable {
    case details

    nonisolated var id: String { rawValue }
    nonisolated var title: String { "Details" }
    nonisolated var systemImage: String { "info.circle" }

    var body: some View {
        MessageInspectorView()
    }
}

private struct MessageInspectorView: View {
    var body: some View {
        Form {
            Section("Message Info") {
                LabeledContent("Status", value: "Delivered")
                LabeledContent("Encrypted", value: "Yes")
                LabeledContent("Size", value: "12 KB")
            }
        }
        .formStyle(.grouped)
    }
}

// MARK: - Content Column (Message List)

private struct MessageListView: View {
    @Binding var selection: MockMessage?

    var body: some View {
        List(mockMessages, selection: $selection) { message in
            MessageRowView(message: message)
                .tag(message)
        }
        .listStyle(.plain)
        .navigationTitle("Inbox")
        #if !os(macOS)
        .toolbarTitleDisplayMode(.inline)
        #endif
    }
}

private struct MessageRowView: View {
    let message: MockMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if !message.isRead {
                    Circle()
                        .fill(.blue)
                        .frame(width: 8, height: 8)
                }
                Text(message.sender)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text(message.date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(message.subject)
                .font(.subheadline)
                .fontWeight(message.isRead ? .regular : .semibold)
                .lineLimit(1)
            Text(message.preview)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Detail Column (Message Detail)

private struct MessageDetailView: View {
    let message: MockMessage?

    var body: some View {
        if let message {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(message.subject)
                            .font(.title2)
                            .fontWeight(.semibold)

                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundStyle(.secondary)
                            VStack(alignment: .leading) {
                                Text(message.sender)
                                    .font(.headline)
                                Text(message.date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button { } label: {
                                Image(systemName: "arrowshape.turn.up.left")
                            }
                            Button { } label: {
                                Image(systemName: "arrowshape.turn.up.right")
                            }
                            Button { } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }

                    Divider()

                    // Body
                    Text(message.body)
                        .font(.body)
                        .textSelection(.enabled)
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        } else {
            ContentUnavailableView(
                "No Message Selected",
                systemImage: "envelope",
                description: Text("Select a message from the list to read it.")
            )
        }
    }
}
