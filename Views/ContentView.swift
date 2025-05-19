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
    @Environment(\.modelContext) private var modelContext
    @Query private var opportunities: [Opportunity]
    
    var body: some View {
        NavigationView {
            List(opportunities) { opportunity in
                VStack(alignment: .leading) {
                    Text(opportunity.title)
                        .font(.headline)
                    Text(opportunity.company)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Opportunities")
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
