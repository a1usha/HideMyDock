//
//  HideMyDockApp.swift
//  HideMyDock
//
//  Created by Александр Ушаев on 23.11.2021.
//
//

import SwiftUI

@main
struct HideMyDockApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
