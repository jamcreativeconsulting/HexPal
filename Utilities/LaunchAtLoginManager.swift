//
//  LaunchAtLoginManager.swift
//  HexPal
//
//  Manages launch at login functionality for HEXPal.
//  Uses SMAppService for macOS 13+ and SMLoginItemSetEnabled for older versions.
//

import Cocoa
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
            // Check UserDefaults first
            if UserDefaults.standard.object(forKey: LaunchAtLoginManager.launchAtLoginKey) != nil {
                return UserDefaults.standard.bool(forKey: LaunchAtLoginManager.launchAtLoginKey)
            }
            // Default to false (not enabled by default)
            return false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LaunchAtLoginManager.launchAtLoginKey)
            updateLaunchAtLogin(enabled: newValue)
        }
    }
    
    // MARK: - Initialization
    
    private init() {
        // Sync UserDefaults preference with actual system state on init
        syncWithSystemState()
    }
    
    // MARK: - Private Methods
    
    /// Updates the launch at login setting in the system.
    ///
    /// - Parameter enabled: Whether to enable launch at login
    private func updateLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            // Use modern SMAppService API
            updateLaunchAtLoginModern(enabled: enabled)
        } else {
            // Use legacy SMLoginItemSetEnabled API
            updateLaunchAtLoginLegacy(enabled: enabled)
        }
    }
    
    /// Updates launch at login using SMAppService (macOS 13+).
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
            // Show user-friendly error message
            let errorMessage = "Error: \(error.localizedDescription)"
            ErrorHandler.showError(.launchAtLoginFailed, additionalInfo: errorMessage)
        }
    }
    
    /// Updates launch at login using SMLoginItemSetEnabled (macOS < 13).
    ///
    /// - Note: The legacy API requires a helper app bundle. Since HEXPal doesn't use a helper app,
    ///   this will attempt to use the main bundle ID. If it fails, the preference is still saved
    ///   in UserDefaults, and users can manually enable it in System Preferences → Users & Groups → Login Items.
    private func updateLaunchAtLoginLegacy(enabled: Bool) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            ErrorHandler.showError(.launchAtLoginFailed, additionalInfo: "Could not find app bundle identifier.")
            return
        }
        
        // Attempt to use legacy API (may fail without helper app, but preference is saved)
        let success = SMLoginItemSetEnabled(bundleIdentifier as CFString, enabled)
        
        if !success && enabled {
            // Only show error if trying to enable (disabling failures are less critical)
            ErrorHandler.showError(.launchAtLoginFailed, additionalInfo: "On macOS < 13, you may need to enable manually in System Settings → Users & Groups → Login Items.")
        }
    }
    
    /// Syncs UserDefaults preference with actual system state.
    ///
    /// Checks the actual system state and updates UserDefaults if they differ.
    /// This handles cases where the user manually changes the setting in System Settings.
    private func syncWithSystemState() {
        let userDefaultsValue = UserDefaults.standard.bool(forKey: LaunchAtLoginManager.launchAtLoginKey)
        let systemValue = checkSystemState()
        
        // If UserDefaults says enabled but system says disabled (or vice versa),
        // update UserDefaults to match system state
        if userDefaultsValue != systemValue {
            UserDefaults.standard.set(systemValue, forKey: LaunchAtLoginManager.launchAtLoginKey)
        }
    }
    
    /// Checks the actual system state of launch at login.
    ///
    /// - Returns: True if launch at login is enabled in the system
    private func checkSystemState() -> Bool {
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            return service.status == .enabled
        } else {
            // For legacy API, we can't easily check status, so return UserDefaults value
            return UserDefaults.standard.bool(forKey: LaunchAtLoginManager.launchAtLoginKey)
        }
    }
}
