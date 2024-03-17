//
//  StatusBarManager.swift
//  QuickGPT
//
//  Created by MikyInDevMode on 15/03/24.
//

import AppKit
import SwiftUI

class StatusBarManager {
    private var statusBarItem: NSStatusItem?
    private var popover: NSPopover

    init() {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 300)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView())

        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusBarItem?.button {
            button.image = NSImage(systemSymbolName: "dot.square", accessibilityDescription: "QuickGPT")
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusBarItem?.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}
