//
//  ContentView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/11/25.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct ContentView: View {
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    @StateObject private var appState = AppState()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var opportunities: [Opportunity]
    
    var body: some View {
        if !hasSeenOnboarding {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
        } else if appState.isLoggedIn {
            MainContentView()
                .environmentObject(appState)
        } else {
            SplashView()
                .environmentObject(appState)
        }
    }
}


#Preview {
    if #available(iOS 17.0, *) {
        ContentView()
    } else {
        // Fallback on earlier versions
    }
}
