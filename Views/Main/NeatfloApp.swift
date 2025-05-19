//
//  NeatfloApp.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/27/25.
//

import SwiftUI
import SwiftData

@main
struct NeatfloApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var loginData = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                SplashView()
                    .modelContainer(AppDelegate.sharedModelContainer)
                    .environmentObject(appState)
            } else {
                SplashView()
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                    .environmentObject(appState)
            }
        }
    }
}



