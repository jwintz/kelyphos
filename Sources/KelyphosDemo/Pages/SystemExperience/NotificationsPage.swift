// NotificationsPage.swift - UNUserNotificationCenter demo

import SwiftUI
import UserNotifications

struct NotificationsPage: View {
    @State private var permissionStatus = "Unknown"
    @State private var errorMessage: String?

    /// Whether we're running inside a proper .app bundle (required for notifications).
    private var hasBundleIdentifier: Bool {
        Bundle.main.bundleIdentifier != nil
    }

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("notifications")!) {
            VStack(alignment: .leading, spacing: 20) {
                if !hasBundleIdentifier {
                    GlassSection(title: "Bundle Required") {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Notifications require a proper app bundle.", systemImage: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)

                            Text("When running from `swift build`, the executable has no bundle identifier. Build and run from Xcode to test notifications, or use `open .build/debug/KelyphosDemo.app` if an app bundle target is available.")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                GlassSection(title: "Request Permission") {
                    VStack(alignment: .leading, spacing: 12) {
                        Button("Request Notification Permission") {
                            requestPermission()
                        }
                        .disabled(!hasBundleIdentifier)

                        Text("Status: \(permissionStatus)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }

                GlassSection(title: "Send Test Notification") {
                    Button("Send Local Notification") {
                        sendTestNotification()
                    }
                    .disabled(!hasBundleIdentifier)
                }

                GlassSection(title: "Notification Types") {
                    VStack(alignment: .leading, spacing: 4) {
                        Label("Banner — Brief overlay at top of screen", systemImage: "rectangle.topthird.inset.filled")
                        Label("Alert — Persistent until dismissed", systemImage: "exclamationmark.triangle")
                        Label("Badge — Count on app icon", systemImage: "app.badge")
                        Label("Sound — Audio alert", systemImage: "speaker.wave.2")
                    }
                    .font(.system(size: 12))
                }
            }
        }
    }

    private func requestPermission() {
        guard hasBundleIdentifier else {
            errorMessage = "Cannot request permissions without a bundle identifier."
            return
        }
        errorMessage = nil
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            Task { @MainActor in
                if let error {
                    errorMessage = error.localizedDescription
                    permissionStatus = "Error"
                } else {
                    permissionStatus = granted ? "Granted" : "Denied"
                }
            }
        }
    }

    private func sendTestNotification() {
        guard hasBundleIdentifier else { return }
        let content = UNMutableNotificationContent()
        content.title = "Kelyphos Demo"
        content.body = "This is a test notification from the HIG Showcase."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
