//
//  LaunchAtLoginManager.swift
//  HexPal
//
//  Manages launch at login functionality for HEXPal.
//  Uses SMAppService for macOS 13+ and SMLoginItemSetEnabled for older versions.
//  Lives in Controllers/ because it uses ServiceManagement and presents errors via ErrorHandler.
//

import Foundation
import ServiceManagement

/// Manages launch at login functionality for HEXPal.
///
/// Provides a unified interface for enabling/disabling launch at login across
/// different macOS versions. Uses modern SMAppService API on macOS 13+ and
/// falls back to legacy SMLoginItemSetEnabled for older versions.
///
/// ## Usage
/// ```swift
/// // Enable launch at login
/// LaunchAtLoginManager.shared.isEnabled = true
///
/// // Check current status
/// let isEnabled = LaunchAtLoginManager.shared.isEnabled
/// ```
///
/// - Note: Requires app to be code-signed for launch at login to work
class LaunchAtLoginManager {

    // MARK: - Singleton

    /// Shared instance for launch at login management
    static let shared = LaunchAtLoginManager()

    // MARK: - UserDefaults Key

    private static let launchAtLoginKey = "HexPal.launchAtLogin"

    // MARK: - Properties

    /// Whether launch at login is enabled.
    ///
    /// Setting this property enables or disables launch at login.
    /// The preference is persisted to UserDefaults.
    var isEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: LaunchAtLoginManager.launchAtLoginKey) != nil {
                return UserDefaults.standard.bool(forKey: LaunchAtLoginManager.launchAtLoginKey)
            }
            return false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LaunchAtLoginManager.launchAtLoginKey)
            updateLaunchAtLogin(enabled: newValue)
        }
    }

    // MARK: - Initialization

    private init() {
        syncWithSystemState()
    }

    // MARK: - Private Methods

    private func updateLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            updateLaunchAtLoginModern(enabled: enabled)
        } else {
            updateLaunchAtLoginLegacy(enabled: enabled)
        }
    }

    @available(macOS 13.0, *)
    private func updateLaunchAtLoginModern(enabled: Bool) {
        let service = SMAppService.mainApp

        do {
            if enabled {
                try service.register()
            } else {
                try service.unregister()
            }
        } catch {
            let errorMessage = "Error: \(error.localizedDescription)"
            ErrorHandler.showError(.launchAtLoginFailed, additionalInfo: errorMessage)
        }
    }

    private func updateLaunchAtLoginLegacy(enabled: Bool) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            ErrorHandler.showError(.launchAtLoginFailed, additionalInfo: "Could not find app bundle identifier.")
            return
        }

        let success = SMLoginItemSetEnabled(bundleIdentifier as CFString, enabled)

        if !success && enabled {
            ErrorHandler.showError(.launchAtLoginFailed, additionalInfo: "On macOS < 13, you may need to enable manually in System Settings → Users & Groups → Login Items.")
        }
    }

    private func syncWithSystemState() {
        let userDefaultsValue = UserDefaults.standard.bool(forKey: LaunchAtLoginManager.launchAtLoginKey)
        let systemValue = checkSystemState()

        if userDefaultsValue != systemValue {
            UserDefaults.standard.set(systemValue, forKey: LaunchAtLoginManager.launchAtLoginKey)
        }
    }

    private func checkSystemState() -> Bool {
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            return service.status == .enabled
        } else {
            return UserDefaults.standard.bool(forKey: LaunchAtLoginManager.launchAtLoginKey)
        }
    }
}
