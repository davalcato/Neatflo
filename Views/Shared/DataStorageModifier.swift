//
//  DataStorageModifier.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/19/25.
//

import SwiftUI
import SwiftData

struct DataStorageModifier: ViewModifier {
    @EnvironmentObject var appState: AppState
    
    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content
                .modelContainer(for: Opportunity.self)
                .environmentObject(appState)
        } else {
            content
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(appState)
        }
    }
}

// Preview Provider
#Preview {
    // Example usage with a Text view
    Text("Data Storage Modifier Test")
        .modifier(DataStorageModifier())
        .environmentObject(AppState()) // Provide required environment objects
    
    // Alternatively, preview with your actual content view
    /*
    ContentView()
        .modifier(DataStorageModifier())
        .environmentObject(AppState())
    */
}
