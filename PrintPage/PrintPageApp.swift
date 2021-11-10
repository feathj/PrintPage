//
//  PrintPageApp.swift
//  PrintPage
//
//  Created by Jonathan Featherstone on 10/28/21.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

@main
struct PrintPageApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        Settings {
            SettingsView()
        }
    }
}
