//
//  ColorHistoryManager.swift
//  HexPal
//
//  Manages a history of recently picked colors.
//  Persists colors to UserDefaults for access across app launches.
//

import Cocoa

/// Manages the history of recently picked colors.
///
/// Stores up to 10 recent colors in UserDefaults, allowing users to quickly
/// access previously picked colors without re-picking them.
///
/// ## Usage
/// ```swift
/// // Add a color to history
/// ColorHistoryManager.shared.addColor("#FF5733")
///
/// // Get recent colors
/// let colors = ColorHistoryManager.shared.recentColors
///
/// // Copy a color to clipboard
/// ColorHistoryManager.shared.copyToClipboard("#FF5733")
/// ```
class ColorHistoryManager {
    
    // MARK: - Singleton
    
    /// Shared instance for app-wide access
    static let shared = ColorHistoryManager()
    
    // MARK: - Constants
    
    /// Maximum number of colors to store in history
    private static let maxColors = 10
    
    /// UserDefaults key for storing color history
    private static let historyKey = "HexPal.colorHistory"
    
    // MARK: - Properties
    
    /// Recent colors, most recent first
    private(set) var recentColors: [String] = []
    
    /// Notification posted when color history changes
    static let historyDidChangeNotification = Notification.Name("ColorHistoryDidChange")
    
    // MARK: - Initialization
    
    private init() {
        loadHistory()
    }
    
    // MARK: - Public Methods
    
    /// Adds a color to the history.
    ///
    /// The color is added to the front of the list. If it already exists,
    /// it's moved to the front. The list is limited to 10 colors.
    ///
    /// - Parameter hex: The HEX code to add (e.g., "#FF5733")
    func addColor(_ hex: String) {
        // Normalize the hex code
        let normalizedHex = normalizeHex(hex)
        
        // Remove if already exists (we'll add to front)
        recentColors.removeAll { $0.uppercased() == normalizedHex.uppercased() }
        
        // Add to front
        recentColors.insert(normalizedHex, at: 0)
        
        // Limit to max colors
        if recentColors.count > ColorHistoryManager.maxColors {
            recentColors = Array(recentColors.prefix(ColorHistoryManager.maxColors))
        }
        
        // Save and notify
        saveHistory()
        NotificationCenter.default.post(name: ColorHistoryManager.historyDidChangeNotification, object: nil)
    }
    
    /// Copies a HEX code to the clipboard.
    ///
    /// - Parameter hex: The HEX code to copy
    /// - Returns: True if copy succeeded, false otherwise
    @discardableResult
    func copyToClipboard(_ hex: String) -> Bool {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        return pasteboard.setString(hex, forType: .string)
    }
    
    /// Clears all color history.
    func clearHistory() {
        recentColors.removeAll()
        saveHistory()
        NotificationCenter.default.post(name: ColorHistoryManager.historyDidChangeNotification, object: nil)
    }
    
    /// Returns true if there are any colors in history.
    var hasColors: Bool {
        return !recentColors.isEmpty
    }
    
    // MARK: - Private Methods
    
    /// Loads color history from UserDefaults.
    private func loadHistory() {
        if let saved = UserDefaults.standard.stringArray(forKey: ColorHistoryManager.historyKey) {
            recentColors = saved
        }
    }
    
    /// Saves color history to UserDefaults.
    private func saveHistory() {
        UserDefaults.standard.set(recentColors, forKey: ColorHistoryManager.historyKey)
    }
    
    /// Normalizes a HEX code to uppercase with # prefix.
    ///
    /// - Parameter hex: The HEX code to normalize
    /// - Returns: Normalized HEX code (e.g., "#FF5733")
    private func normalizeHex(_ hex: String) -> String {
        var result = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if !result.hasPrefix("#") {
            result = "#" + result
        }
        return result
    }
}
