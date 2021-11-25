//
// Created by Александр Ушаев on 23.11.2021.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    
    let enableDockAutoHide = NSAppleScript(source:
    """
    tell application "System Events"
        set autohide of dock preferences to true
    end tell
    """)
    
    let disableDockAutoHide = NSAppleScript(source:
    """
    tell application "System Events"
        set autohide of dock preferences to false
    end tell
    """)
    
    let utils: Utils
    
    var spacesToHide: [String] = []
    
    override init() {
        utils = Utils()
        
        enableDockAutoHide?.compileAndReturnError(nil)
        disableDockAutoHide?.compileAndReturnError(nil)
        
        super.init()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.up.fill", accessibilityDescription: nil)
        }
        
        constructMenu()
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.spaceChange), name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Show Dock", action: #selector(AppDelegate.showDockForDesktop(_:)), keyEquivalent: "s"))
        menu.addItem(NSMenuItem(title: "Hide Dock", action: #selector(AppDelegate.hideDockForDesktop(_:)), keyEquivalent: "h"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit HideMyDock", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func hideDockForDesktop(_ sender: Any?) {
        
        let spaceId = utils.activeSpaceIdentifier()
        
        if (!spacesToHide.contains(spaceId!)) {
            spacesToHide.append(spaceId!)
        }
        
        hideDock()
    }
    
    private func hideDock() {
        
        enableDockAutoHide?.executeAndReturnError(nil)
        
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.down.fill", accessibilityDescription: nil)
        }
    }
    
    @objc func showDockForDesktop(_ sender: Any?) {
        
        let spaceId = utils.activeSpaceIdentifier()
        spacesToHide.removeAll { $0 == spaceId! }
        
        showDock()
    }
    
    private func showDock() {
        
        disableDockAutoHide?.executeAndReturnError(nil)
        
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.up.fill", accessibilityDescription: nil)
        }
    }
    
    @objc func spaceChange() {
        
        let spaceId = utils.activeSpaceIdentifier()
        
        if (spacesToHide.contains(where: { $0 == spaceId! })) {
            hideDock()
        } else {
            showDock()
        }
    }
}
