//
// Created by Александр Ушаев on 23.11.2021.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.up.fill", accessibilityDescription: nil)
        }
        
        constructMenu()
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func printQuote(_ sender: Any?) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }
}
