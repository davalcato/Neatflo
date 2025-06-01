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
            Opportunity(
                title: "Investor Intro",
                company: "Neatflo",
                summary: "AI for business",
                matchStrength: 0.9,
                timestamp: Date(),
                tags: ["AI", "Business", "Funding"],
                profile: Opportunity.matchProfile(for: "Neatflo")
            ),
            Opportunity(
                title: "Co-Founder Match",
                company: "TechLift",
                summary: "ML Scaling",
                matchStrength: 0.8,
                timestamp: Date(),
                tags: ["Machine Learning", "Startup", "Co-Founder"],
                profile: Opportunity.matchProfile(for: "TechLift")
            )
        ]
        
        isLoading = false
    }
    
    // MARK: - Add Mock
    private func addMockData() {
        opportunities.append(
            Opportunity(
                title: "Investor Intro",
                company: "NewCo",
                summary: "New opportunity",
                matchStrength: 0.7,
                timestamp: Date(),
                tags: ["New", "Investor", "Intro"],
                profile: Opportunity.matchProfile(for: "NewCo")
            )
        )
    }
    
    
    // MARK: - Card Subview
    @available(iOS 17.0, *)
    struct OpportunityCard<Destination: View>: View {
        let opportunity: Opportunity
        let destination: () -> Destination
        
        @State private var isPressed = false
        @State private var navigate = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(opportunity.title)
                        .font(.headline)
                    Spacer()
                    Text(matchPercentage)
                        .foregroundColor(matchColor)
                        .font(.subheadline.bold())
                }
                
                Text(opportunity.company)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(opportunity.summary)
                    .font(.body)
                
                Text(opportunity.timestamp.formatted(.dateTime.month().day().year()))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    Spacer()
                    Button(action: {
                        navigate = true
                    }) {
                        Text("View Details")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(isPressed ? Color.blue.opacity(0.7) : Color.blue)
                            .cornerRadius(8)
                            .scaleEffect(isPressed ? 0.97 : 1.0)
                    }
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.01)
                            .onChanged { _ in withAnimation { isPressed = true } }
                            .onEnded { _ in withAnimation { isPressed = false } }
                    )
                    
                    NavigationLink(destination: destination(), isActive: $navigate) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 6)
        }
        
        private var matchPercentage: String {
            String(format: "%.0f%%", opportunity.matchStrength * 100)
        }
        
        private var matchColor: Color {
            opportunity.matchStrength > 0.85 ? .green :
            opportunity.matchStrength > 0.7 ? .orange : .red
        }
    }
}

    
