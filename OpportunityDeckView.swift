//
//  OpportunityDeckView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import SwiftUI

@available(iOS 17, *)
struct OpportunityDeckView: View {
    @Environment(\.dismiss) var dismiss

    @State private var opportunities: [Opportunity] = [
        Opportunity(title: "Seed Funding", company: "Neatflo", summary: "AI for business", matchStrength: 0.9, timestamp: Date()),
        Opportunity(title: "Series A", company: "TechLift", summary: "ML Scaling", matchStrength: 0.8, timestamp: Date()),
    ]

    var body: some View {
        VStack(spacing: 12) {
            // Top bar
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.accentColor)
                }
                Spacer()
                Text("Neatflo Matches")
                    .font(.title.bold())
                Spacer()
                Spacer() // Balance spacing
            }
            .padding()

            // Swipe deck
            ZStack {
                ForEach(opportunities.indices.reversed(), id: \.self) { index in
                    SwipeableCardView(
                        content: {
                            OpportunityCard(opportunity: opportunities[index])
                        },
                        onSwipeLeft: { removeCard(at: index) },
                        onSwipeRight: { removeCard(at: index) }
                    )
                    .padding(.horizontal)
                }
            }
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
    }

    private func removeCard(at index: Int) {
        if opportunities.indices.contains(index) {
            opportunities.remove(at: index)
        }
    }
}


#Preview {
    if #available(iOS 17, *) {
        OpportunityDeckView()
    } else {
        // Fallback on earlier versions
    }
}
