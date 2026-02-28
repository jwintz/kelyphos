// AppearanceObserver.swift - System appearance change listener

import AppKit
import SwiftUI

/// Listens for system appearance changes and updates KelyphosColorTheme.
/// Attach via `.onAppear { observer.start(theme) }`.
@MainActor
@Observable
public final class AppearanceObserver {
    private var observation: NSObjectProtocol?

    public init() {}

    /// Start listening for system appearance changes.
    public func start(updating theme: KelyphosColorTheme) {
        observation = DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil,
            queue: .main
        ) { [weak theme] _ in
            MainActor.assumeIsolated {
                theme?.refreshAppearance()
            }
        }
    }

    /// Stop listening.
    public func stop() {
        if let obs = observation {
            DistributedNotificationCenter.default().removeObserver(obs)
            observation = nil
        }
    }

    deinit {
        // observation cleanup handled by stop()
    }
}
