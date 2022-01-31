//
//  MenuBarUtils.swift
//  HideMyDock
//
//  Created by Александр Ушаев on 31.01.2022.
//

import Foundation
import Cocoa

class MenuBarUtils {
    
    let enableMenuBarAutoHide = NSAppleScript(source:
    """
    tell application "System Events"
        tell dock preferences to set autohide menu bar to true
    end tell
    """)
    
    let disableMenuBarAutoHide = NSAppleScript(source:
    """
    tell application "System Events"
        tell dock preferences to set autohide menu bar to false
    end tell
    """)
    
    init() {
        enableMenuBarAutoHide?.compileAndReturnError(nil)
        disableMenuBarAutoHide?.compileAndReturnError(nil)
    }
    
    func getMenuBarSize() -> CGFloat {
        let maxSize = NSScreen.main!.frame.maxY
        let visibleSize = NSScreen.main!.visibleFrame.maxY
        return maxSize - visibleSize
    }
    
    func isMenuBarHidden() -> Bool {
        let size = getMenuBarSize()
        return size == 0
    }
}
