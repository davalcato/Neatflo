//
//  NeatfloApp.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/27/25.
//

import SwiftUI

@main
struct NeatfloApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                SplashView()
                    .modelContainer(AppDelegate.sharedModelContainer)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


struct DataStorageModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content
                .modelContainer(for: Opportunity.self)
        } else {
            content
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
