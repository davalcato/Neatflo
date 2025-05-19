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
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasSeenOnboarding {
                    SplashView()
                        .environmentObject(appState)
                        .environmentObject(loginData)
                        .background(Color(.systemBackground).ignoresSafeArea())
                } else {
                    OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                        .environmentObject(appState)
                        .background(Color(.systemBackground).ignoresSafeArea())
                }
            }
            .modifier(ModelContainerModifier())
        }
    }
}

private struct ModelContainerModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            return content
                .modelContainer(AppDelegate.sharedModelContainer)
        } else {
            return content
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}




