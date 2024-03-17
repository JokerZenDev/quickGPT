//
//  QuickGPTApp.swift
//  QuickGPT
//
//  Created by MikyInDevMode on 15/03/24.
//

import SwiftUI

@main
struct QuickGPTApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings { }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarManager: StatusBarManager?
    var eventMonitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarManager = StatusBarManager()
        setupGlobalKeyboardShortcut()
        checkAccessibilityPermissions()
    }
    
    func setupGlobalKeyboardShortcut() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else { return }
            // Example: Command + Option + P
            if event.modifierFlags.contains([.command, .option]) && event.keyCode == 5 {
                self.statusBarManager?.togglePopover(nil)
            }
        }
    }
    
    func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)

        if !accessEnabled {
            promptForAccessibilityAccess()
        }
    }

    func promptForAccessibilityAccess() {
        let alert = NSAlert()
        alert.messageText = "Accessibility Permission Required"
        alert.informativeText = "Please grant Accessibility permissions in System Preferences to allow this app to use global keyboard shortcuts."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open System Preferences")
        alert.addButton(withTitle: "Cancel")

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
                NSWorkspace.shared.open(url)
            }
        }
    }
}
