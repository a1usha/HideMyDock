//
// Created by Александр Ушаев on 23.11.2021.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    
    var enableDockAutoHide = NSAppleScript(source:
    """
    tell application "System Events"
        set autohide of dock preferences to true
    end tell
    """)
    
    var disableDockAutoHide = NSAppleScript(source:
    """
    tell application "System Events"
        set autohide of dock preferences to false
    end tell
    """)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.up.fill", accessibilityDescription: nil)
        }
        
        constructMenu()
        
//        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.spaceChange), name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Hide Dock", action: #selector(AppDelegate.spaceChange(_:)), keyEquivalent: "h"))
        menu.addItem(NSMenuItem(title: "Show Dock", action: #selector(AppDelegate.showDock(_:)), keyEquivalent: "s"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit HideMyDock", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func hideDock(_ sender: Any?) {
        enableDockAutoHide?.executeAndReturnError(nil)
        
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.down.fill", accessibilityDescription: nil)
        }
    }
    
    @objc func showDock(_ sender: Any?) {
        disableDockAutoHide?.executeAndReturnError(nil)
        
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.up.fill", accessibilityDescription: nil)
        }
    }
    
    @objc func spaceChange(_ sender: Any?) {
        let utils = Utils()
        
        print(utils.activeSpaceIdentifier())
    }
}
