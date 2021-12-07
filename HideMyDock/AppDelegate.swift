//
// Created by Александр Ушаев on 23.11.2021.
//

import Cocoa
import SwiftUI
import Foundation
import LaunchAtLogin

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
        
        if (isDockHidden()) {
            hideDockForDesktop(nil)
        } else {
            showDockForDesktop(nil)
        }
        
        constructMenu()
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.spaceChange), name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
    }
    
    private func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Show Dock", action: #selector(AppDelegate.showDockForDesktop(_:)), keyEquivalent: "s"))
        menu.addItem(NSMenuItem(title: "Hide Dock", action: #selector(AppDelegate.hideDockForDesktop(_:)), keyEquivalent: "h"))
        
        menu.addItem(NSMenuItem.separator())
        
        let launchAtLoginMenuItem = NSMenuItem(title: "Launch at login", action:
                                                #selector(AppDelegate.launchAtLogin(_ :)), keyEquivalent: "l")
        
        launchAtLoginMenuItem.state = LaunchAtLogin.isEnabled ? NSControl.StateValue.on : NSControl.StateValue.off
        
        menu.addItem(launchAtLoginMenuItem)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit HideMyDock", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func launchAtLogin(_ sender: Any?) {
        
        let menuItem = sender as! NSMenuItem
        
        if (menuItem.state == NSControl.StateValue.off) {
            LaunchAtLogin.isEnabled = true
            menuItem.state = NSControl.StateValue.on
        } else {
            LaunchAtLogin.isEnabled = false
            menuItem.state = NSControl.StateValue.off
        }
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
            menuButton.image = NSImage(systemSymbolName: "dock.arrow.down.rectangle", accessibilityDescription: nil)
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
            menuButton.image = NSImage(systemSymbolName: "dock.arrow.up.rectangle", accessibilityDescription: nil)
        }
    }
    
    @objc func spaceChange() {
        
        let spaceId = utils.activeSpaceIdentifier()
        if (spaceId == nil) {
            return
        }
        
        if (spacesToHide.contains(where: { $0 == spaceId! })) {
            hideDock()
        } else {
            showDock()
        }
    }
    
    private func isDockHidden() -> Bool {
        let dockSize = getDockSize()
        
        if dockSize < 25 {
            return true
        } else {
            return false
        }
    }
}
