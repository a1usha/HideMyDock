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
//        enableDockAutoHide?.executeAndReturnError(nil)
        
//        do {
//            try print(safeShell("defaults read com.apple.spaces"))
//        } catch {
//
//        }
//        let defaults = UserDefaults()
//        defaults.addSuite(named: <#T##String#>)
        
        if let theDefaults = UserDefaults(suiteName: "com.apple.spaces") {
            theDefaults.synchronize()
            
            let spacesDisplayConfiguration = theDefaults.dictionary(forKey: "SpacesDisplayConfiguration")
            let managementData = spacesDisplayConfiguration?["Management Data"] as! [String : Any?]
            let monitors = managementData["Monitors"] as! NSArray
            let currentSpace = (monitors[0] as? [String : Any?])!["Current Space"]
            
            
            print(currentSpace)
        }
    }
    
    func safeShell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated

        do {
            try task.run() //<--updated
        }
        catch { throw error }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}
