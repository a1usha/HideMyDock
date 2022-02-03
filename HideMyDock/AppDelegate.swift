//
// Created by Александр Ушаев on 23.11.2021.
//

import Cocoa
import SwiftUI
import Foundation
import LaunchAtLogin

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
        
    let utils: Utils
    let dockUtils: DockUtils
    let menuBarUtils: MenuBarUtils
    
    var spacesToHideDock: [String] = []
    var spacesToHideMenuBar: [String] = []
    
    override init() {
        utils = Utils()
        
        dockUtils = DockUtils()
        menuBarUtils = MenuBarUtils()
                
        super.init()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if (dockUtils.isDockHidden()) {
            hideDockForDesktop(nil)
        } else {
            showDockForDesktop(nil)
        }
        
        if (menuBarUtils.isMenuBarHidden()) {
            hideMenuBarForDesktop(nil)
        } else {
            showMenuBarForDesktop(nil)
        }
        
        constructMenu()
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.spaceChange), name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
    }
    
    private func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Show All", action: #selector(AppDelegate.showAll(_:)), keyEquivalent: "a"))
        menu.addItem(NSMenuItem(title: "Hide All", action: #selector(AppDelegate.hideAll(_:)), keyEquivalent: "z"))
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Show Dock", action: #selector(AppDelegate.showDockForDesktop(_:)), keyEquivalent: "d"))
        menu.addItem(NSMenuItem(title: "Hide Dock", action: #selector(AppDelegate.hideDockForDesktop(_:)), keyEquivalent: "c"))
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Show Menu Bar", action: #selector(AppDelegate.showMenuBarForDesktop(_:)), keyEquivalent: "m"))
        menu.addItem(NSMenuItem(title: "Hide Menu Bar", action: #selector(AppDelegate.hideMenuBarForDesktop(_:)), keyEquivalent: "n"))
        
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
    
    @objc func showAll(_ sender: Any?) {
        showMenuBarForDesktop(nil)
        showDockForDesktop(nil)
    }
    
    @objc func hideAll(_ sender: Any?) {
        hideMenuBarForDesktop(nil)
        hideDockForDesktop(nil)
    }
    
    @objc func showMenuBarForDesktop(_ sender: Any?) {
        
        let spaceId = utils.activeSpaceIdentifier()
        spacesToHideMenuBar.removeAll { $0 == spaceId! }
        
        showMenuBar()
    }
    
    private func showMenuBar() {
        menuBarUtils.disableMenuBarAutoHide?.executeAndReturnError(nil)
    }
    
    @objc func hideMenuBarForDesktop(_ sender: Any?) {
        
        let spaceId = utils.activeSpaceIdentifier()
        
        if (!spacesToHideMenuBar.contains(spaceId!)) {
            spacesToHideMenuBar.append(spaceId!)
        }
        
        hideMenuBar()
    }
    
    private func hideMenuBar() {
        menuBarUtils.enableMenuBarAutoHide?.executeAndReturnError(nil)
    }
    
    @objc func hideDockForDesktop(_ sender: Any?) {
        
        let spaceId = utils.activeSpaceIdentifier()
        
        if (!spacesToHideDock.contains(spaceId!)) {
            spacesToHideDock.append(spaceId!)
        }
        
        hideDock()
    }
    
    private func hideDock() {
        
        dockUtils.enableDockAutoHide?.executeAndReturnError(nil)
        
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "dock.arrow.down.rectangle", accessibilityDescription: nil)
        }
    }
    
    @objc func showDockForDesktop(_ sender: Any?) {
        
        let spaceId = utils.activeSpaceIdentifier()
        spacesToHideDock.removeAll { $0 == spaceId! }
        
        showDock()
    }
    
    private func showDock() {
        
        dockUtils.disableDockAutoHide?.executeAndReturnError(nil)
        
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "dock.arrow.up.rectangle", accessibilityDescription: nil)
        }
    }
    
    @objc func spaceChange() {
        
        let spaceId = utils.activeSpaceIdentifier()
        if (spaceId == nil) {
            return
        }
        
        if (spacesToHideDock.contains(where: { $0 == spaceId! })) {
            hideDock()
        } else {
            showDock()
        }
        
        if (spacesToHideMenuBar.contains(where: { $0 == spaceId! })) {
            hideMenuBar()
        } else {
            showMenuBar()
        }
    }
}
