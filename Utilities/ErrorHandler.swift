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
/// ErrorHandler.showError(.launchAtLoginFailed)
/// ```
class ErrorHandler {

    // MARK: - Error Types

    /// Types of errors that can occur in HEXPal.
    enum ErrorType {
        case launchAtLoginFailed
    }

    // MARK: - Public Methods

    /// Shows a user-friendly error alert for the specified error type.
    ///
    /// - Parameters:
    ///   - type: The type of error that occurred
    ///   - additionalInfo: Optional additional context to include in the message
    static func showError(_ type: ErrorType, additionalInfo: String? = nil) {
        let alert = createAlert(for: type, additionalInfo: additionalInfo)

        NSApp.activate(ignoringOtherApps: true)

        let response = alert.runModal()

        if response == .alertSecondButtonReturn {
            if type == .launchAtLoginFailed {
                openLoginItemsSettings()
            }
        }
    }

    // MARK: - Private Methods

    /// Opens System Settings to Login Items.
    private static func openLoginItemsSettings() {
        if #available(macOS 13.0, *) {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.users?LoginItems") {
                NSWorkspace.shared.open(url)
            }
        } else {
            NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Accounts.prefPane"))
        }
    }

    /// Creates an NSAlert for the specified error type.
    private static func createAlert(for type: ErrorType, additionalInfo: String? = nil) -> NSAlert {
        let alert = NSAlert()
        alert.alertStyle = .warning

        switch type {
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

        }

        return alert
    }

}
