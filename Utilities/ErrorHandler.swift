//
//  ErrorHandler.swift
//  HexPal
//
//  Provides user-friendly error handling and messaging for HEXPal.
//  All error messages use plain language and provide actionable guidance.
//

import Cocoa

/// Manages user-friendly error handling and messaging.
///
/// Provides consistent, plain-language error messages with actionable guidance.
/// All errors are presented transparently to help users understand and resolve issues.
///
/// ## Usage
/// ```swift
/// ErrorHandler.showPermissionError(.screenRecording)
/// ```
class ErrorHandler {
    
    // MARK: - Error Types
    
    /// Types of errors that can occur in HEXPal.
    enum ErrorType {
        case screenRecordingPermissionDenied
        case accessibilityPermissionDenied
        case hotkeyRegistrationFailed
        case clipboardCopyFailed
        case launchAtLoginFailed
        case colorConversionFailed
        case multiDisplayConfiguration
    }
    
    // MARK: - Public Methods
    
    /// Shows a user-friendly error alert for the specified error type.
    ///
    /// - Parameters:
    ///   - type: The type of error that occurred
    ///   - additionalInfo: Optional additional context to include in the message
    static func showError(_ type: ErrorType, additionalInfo: String? = nil) {
        let alert = createAlert(for: type, additionalInfo: additionalInfo)
        
        // Activate app to ensure alert appears
        NSApp.activate(ignoringOtherApps: true)
        
        // Show alert modally and handle button actions
        let response = alert.runModal()
        
        // Handle "Open System Settings" or "Open Login Items" button
        if response == .alertSecondButtonReturn {
            if type == .launchAtLoginFailed {
                openLoginItemsSettings()
            } else if type == .screenRecordingPermissionDenied {
                openSystemSettings(for: .screenRecording)
            }
        }
    }
    
    /// Opens System Settings to Login Items.
    private static func openLoginItemsSettings() {
        if #available(macOS 13.0, *) {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.users?LoginItems") {
                NSWorkspace.shared.open(url)
            }
        } else {
            // macOS < 13: Use Users & Groups preference pane
            NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Accounts.prefPane"))
        }
    }
    
    /// Shows a permission error with instructions to enable it in System Settings.
    ///
    /// - Parameter type: The type of permission that was denied
    static func showPermissionError(_ type: PermissionType) {
        let alert = createPermissionAlert(for: type)
        
        NSApp.activate(ignoringOtherApps: true)
        
        let response = alert.runModal()
        
        // If user clicks "Open System Settings", open the appropriate pane
        if response == .alertSecondButtonReturn {
            openSystemSettings(for: type)
        }
    }
    
    /// Permission types that can be requested.
    enum PermissionType {
        case screenRecording
        case accessibility
    }
    
    // MARK: - Private Methods
    
    /// Creates an NSAlert for the specified error type.
    private static func createAlert(for type: ErrorType, additionalInfo: String? = nil) -> NSAlert {
        let alert = NSAlert()
        alert.alertStyle = .warning
        
        switch type {
        case .screenRecordingPermissionDenied:
            alert.messageText = "Screen Recording Permission Required"
            alert.informativeText = """
            HEXPal needs Screen Recording permission to pick colors from your screen.
            
            \(additionalInfo ?? "")
            
            Please enable Screen Recording in System Settings → Privacy & Security → Screen Recording, then restart HEXPal.
            """
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Open System Settings")
            
        case .accessibilityPermissionDenied:
            alert.messageText = "Accessibility Permission Required"
            alert.informativeText = """
            HEXPal needs Accessibility permission to use global keyboard shortcuts.
            
            Without this permission, you can still use HEXPal by clicking the menu bar icon and selecting "Pick Color".
            
            To enable global hotkeys:
            1. Open System Settings → Privacy & Security → Accessibility
            2. Enable HEXPal
            3. Restart HEXPal if needed
            """
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Open System Settings")
            
        case .hotkeyRegistrationFailed:
            alert.messageText = "Hotkey Registration Failed"
            alert.informativeText = """
            HEXPal couldn't register your keyboard shortcut.
            
            \(additionalInfo ?? "This might be because:")
            • The hotkey is already used by another app
            • Accessibility permission is not granted
            • The app needs to be restarted
            
            You can still use HEXPal by clicking the menu bar icon.
            """
            alert.addButton(withTitle: "OK")
            
        case .clipboardCopyFailed:
            alert.messageText = "Couldn't Copy to Clipboard"
            alert.informativeText = """
            HEXPal couldn't copy the color code to your clipboard.
            
            \(additionalInfo ?? "Please try again or copy manually.")
            """
            alert.addButton(withTitle: "OK")
            
        case .launchAtLoginFailed:
            alert.messageText = "Launch at Login Not Available"
            alert.informativeText = """
            HEXPal couldn't enable launch at login automatically.
            
            \(additionalInfo ?? "You can enable it manually:")
            • Open System Settings → Users & Groups → Login Items
            • Click the + button and add HEXPal
            """
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Open Login Items")
            
        case .colorConversionFailed:
            alert.messageText = "Color Conversion Error"
            alert.informativeText = """
            HEXPal couldn't convert the selected color.
            
            \(additionalInfo ?? "Please try selecting a different color.")
            """
            alert.addButton(withTitle: "OK")
            
        case .multiDisplayConfiguration:
            alert.messageText = "Display Configuration Issue"
            alert.informativeText = """
            HEXPal detected an issue with your display configuration.
            
            \(additionalInfo ?? "Please ensure all displays are properly connected and try again.")
            """
            alert.addButton(withTitle: "OK")
        }
        
        return alert
    }
    
    /// Creates a permission-specific alert with clear instructions.
    private static func createPermissionAlert(for type: PermissionType) -> NSAlert {
        let alert = NSAlert()
        alert.alertStyle = .informational
        
        switch type {
        case .screenRecording:
            alert.messageText = "Screen Recording Permission Needed"
            alert.informativeText = """
            HEXPal needs permission to capture your screen so you can pick colors from anywhere.
            
            How to enable:
            1. Click "Open System Settings" below
            2. Find HEXPal in the list
            3. Turn on the toggle next to HEXPal
            4. Restart HEXPal
            
            Without this permission, HEXPal cannot pick colors from your screen.
            """
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Open System Settings")
            
        case .accessibility:
            alert.messageText = "Accessibility Permission Needed"
            alert.informativeText = """
            HEXPal needs Accessibility permission to use keyboard shortcuts from anywhere.
            
            How to enable:
            1. Click "Open System Settings" below
            2. Find HEXPal in the list
            3. Turn on the toggle next to HEXPal
            4. Restart HEXPal if needed
            
            Without this permission, you can still use HEXPal by clicking the menu bar icon.
            """
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Open System Settings")
        }
        
        return alert
    }
    
    /// Opens System Settings to the appropriate permission pane.
    ///
    /// - Parameter type: The permission type to open settings for
    private static func openSystemSettings(for type: PermissionType) {
        let url: URL?
        
        switch type {
        case .screenRecording:
            if #available(macOS 13.0, *) {
                url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")
            } else {
                url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")
            }
            
        case .accessibility:
            if #available(macOS 13.0, *) {
                url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")
            } else {
                url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")
            }
        }
        
        if let settingsURL = url {
            NSWorkspace.shared.open(settingsURL)
        } else {
            // Fallback: open System Preferences/Settings
            NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Security.prefPane"))
        }
    }
}
