//
//  Creds: https://gist.github.com/wonderbit/c8896ff429a858021a7623f312dcdbf9
//
//  DockUtils.swift
//  HideMyDock
//
//  Created by Александр Ушаев on 25.11.2021.
//

import Foundation
import Cocoa

enum WBDockPosition: Int {
    case bottom = 0
    case left = 1
    case right = 2
}

func getDockPosition() -> WBDockPosition {
    if NSScreen.main!.visibleFrame.origin.y == 0 {
        if NSScreen.main!.visibleFrame.origin.x == 0 {
            return .right
        } else {
            return .left
        }
    } else {
        return .bottom
    }
}

func getDockSize() -> CGFloat {
    let dockPosition = getDockPosition()
    switch dockPosition {
    case .right:
        let size = NSScreen.main!.frame.width - NSScreen.main!.visibleFrame.width
        return size
    case .left:
        let size = NSScreen.main!.visibleFrame.origin.x
        return size
    case .bottom:
        let size = NSScreen.main!.visibleFrame.origin.y
        return size
    }
}

func isDockHidden() -> Bool {
    let dockSize = getDockSize()
    
    if dockSize < 25 {
        return true
    } else {
        return false
    }
}
