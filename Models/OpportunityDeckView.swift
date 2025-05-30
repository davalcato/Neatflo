//
//  OpportunityDeckView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct OpportunityDeckView: View {
    @State private var opportunities: [Opportunity] = [
        Opportunity(
            title: "Seed Funding",
            company: "Neatflo",
            summary: "AI for business",
            matchStrength: 0.9,
            timestamp: Date(),
            profile: Profile(
                name: "Jess Wong",
                title: "CTO",
                company: "Neatflo",
                photo: "jess",
                raised: "$0",
                role: "Engineer",
                bio: "Building productivity tools with AI."
            )
        ),
        Opportunity(
            title: "Series A",
            company: "TechLift",
            summary: "ML Scaling",
            matchStrength: 0.8,
            timestamp: Date(),
            profile: Profile(
                name: "Sarah Kim",
                title: "Partner",
                company: "Future Fund",
                photo: "sarah",
                raised: "$30M",
                role: "Angel Investor",
                bio: "Invests in early-stage tech startups."
            )
        )
    ]
    
    @StateObject private var profileVM = ProfileCardViewModel()
    
    var body: some View {
        ZStack {
            if opportunities.isEmpty {
                Text("No more opportunities")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                ForEach(opportunities.reversed(), id: \.id) { opportunity in
                    SwipeCardView(
                        profile: opportunity.profile,
                        onRemove: { _, _ in
                            removeCard(withId: opportunity.id)
                        }
                    )
                    .padding(.horizontal)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
    }

    private func removeCard(withId id: UUID) {
        opportunities.removeAll { $0.id == id }
    }
}

@available(iOS 17.0, *)
#Preview {
    OpportunityDeckView()
}

