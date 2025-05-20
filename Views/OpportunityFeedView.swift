//
//  OpportunityFeedView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/3/25.
//

import SwiftUI

// MARK: - Main Feed View
@available(iOS 17, *)
struct OpportunityFeedView: View {
    @State private var opportunities: [Opportunity] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    List(opportunities) { opportunity in
                        OpportunityCard(opportunity: opportunity)
                    }
                    .refreshable { await loadData() }
                }
            }
            .navigationTitle("Your Matches")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Mock") { addMockData() }
                }
            }
        }
        .task { await loadData() }
    }
    
    // MARK: - Data Methods
    private func loadData() async {
        isLoading = true
        do {
            opportunities = try await NeatfloDataService.shared.fetchOpportunities()
        } catch {
            print("Error loading opportunities: \(error)")
        }
        isLoading = false
    }
    
    private func addMockData() {
        Task {
            let newOpportunity = Opportunity(
                title: "New Investor Intro",
                company: "Angel Network",
                summary: "Fresh opportunity added for testing",
                matchStrength: 0.78,
                timestamp: Date()
            )
            
            do {
                try await NeatfloDataService.shared.addOpportunity(newOpportunity)
                await loadData()
            } catch {
                print("Error adding opportunity: \(error)")
            }
        }
    }
}

// MARK: - Card Subview
//@available(iOS 17, *)
//struct OpportunityCard: View {
//    let opportunity: Opportunity
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Text(opportunity.title)
//                    .font(.headline)
//                Spacer()
//                Text(String(format: "%.0f%%", opportunity.matchStrength * 100))
//                    .foregroundColor(matchColor)
//            }
//            
//            Text(opportunity.company)
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//            
//            Text(opportunity.summary)
//                .font(.body)
//            
//            Text(opportunity.timestamp.formatted())
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//        .padding(.vertical, 8)
//    }
//    
//    private var matchColor: Color {
//        opportunity.matchStrength > 0.85 ? .green :
//        opportunity.matchStrength > 0.7 ? .orange : .red
//    }
//}
//
//#Preview {
//    if #available(iOS 17, *) {
//        OpportunityFeedView()
//    } else {
//        Text("Preview requires iOS 17+")
//    }
//}
