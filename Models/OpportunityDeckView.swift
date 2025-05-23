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
        Opportunity(title: "Seed Funding", company: "Neatflo", summary: "AI for business", matchStrength: 0.9, timestamp: Date()),
        Opportunity(title: "Series A", company: "TechLift", summary: "ML Scaling", matchStrength: 0.8, timestamp: Date())
    ]
    @StateObject private var profileVM = ProfileCardViewModel()

    var body: some View {
        ZStack {
            if opportunities.isEmpty {
                Text("No more opportunities")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                ForEach(opportunities.indices.reversed(), id: \.self) { index in
                    SwipeableCardView(
                        content: {
                            let opportunity = opportunities[index]

                            switch opportunity.title {
                            case "Seed Funding":
                                return AnyView(ProfileCardView(profiles: profileVM.investorProfiles))
                            case "Series A":
                                return AnyView(ProfileCardView(profiles: profileVM.coFounderProfiles))
                            default:
                                return AnyView(Text("Details not available"))
                            }
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

    // ✅ FIXED: Declared outside the body
    private func removeCard(at index: Int) {
        if opportunities.indices.contains(index) {
            opportunities.remove(at: index)
        }
    }
}

// ✅ FIXED PREVIEW
@available(iOS 17.0, *)
#Preview {
    OpportunityDeckView()
}

