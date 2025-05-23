//
//  OpportunityFeedView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/3/25.
//

import SwiftUI

@available(iOS 17, *)
struct OpportunityFeedView: View {
    @State private var opportunities: [Opportunity] = []
    @State private var isLoading = false
    @StateObject private var profileVM = ProfileCardViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    List(opportunities) { opportunity in
                        OpportunityCard(opportunity: opportunity) {
                            destinationView(for: opportunity)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await loadData()
                    }
                }
            }
            .navigationTitle("Your Matches")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Mock") {
                        addMockData()
                    }
                }
            }
        }
        .task {
            await loadData()
        }
    }

    // MARK: - Destination View
    @ViewBuilder
    private func destinationView(for opportunity: Opportunity) -> some View {
        switch opportunity.title {
        case "Investor Intro":
            ProfileCardView(profiles: profileVM.investorProfiles)
        case "Co-Founder Match":
            ProfileCardView(profiles: profileVM.coFounderProfiles)
        default:
            Text("Details not available")
        }
    }

    // MARK: - Data Load
    private func loadData() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate loading
        opportunities = [
            Opportunity(title: "Investor Intro", company: "Neatflo", summary: "AI for business", matchStrength: 0.9, timestamp: Date()),
            Opportunity(title: "Co-Founder Match", company: "TechLift", summary: "ML Scaling", matchStrength: 0.8, timestamp: Date())
        ]
        isLoading = false
    }

    // MARK: - Add Mock
    private func addMockData() {
        opportunities.append(
            Opportunity(title: "Investor Intro", company: "NewCo", summary: "New opportunity", matchStrength: 0.7, timestamp: Date())
        )
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
