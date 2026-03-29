// AppearanceObserver.swift - System appearance change listener

import SwiftUI

/// Listens for system appearance changes and updates KelyphosColorTheme.
/// Attach via `.onAppear { observer.start(theme) }`.
@MainActor
@Observable
public final class AppearanceObserver {
    #if os(macOS)
    @ObservationIgnored nonisolated(unsafe) private var observation: NSObjectProtocol?
    #endif

    public init() {}

    /// Start listening for system appearance changes.
    public func start(updating theme: any KelyphosColorThemeProtocol) {
        #if os(macOS)
        observation = DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil,
            queue: .main
        ) { [weak theme] _ in
            MainActor.assumeIsolated {
                theme?.refreshAppearance()
            }
        }
        #endif
        // On iOS, SwiftUI handles appearance changes automatically via @Environment(\.colorScheme).
    }

    /// Stop listening.
    public func stop() {
        #if os(macOS)
        if let obs = observation {
            DistributedNotificationCenter.default().removeObserver(obs)
            observation = nil
        }
        #endif
    }

    deinit {
        #if os(macOS)
        if let obs = observation {
            DistributedNotificationCenter.default().removeObserver(obs)
        }
        #endif
    }
}
