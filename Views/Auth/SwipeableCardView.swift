//
//  SwipeableCardView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import SwiftUI

@available(iOS 17, *)
struct SwipeCardStackView: View {
    @State private var opportunities: [Opportunity] = [
        Opportunity(
            title: "Tech CTO",
            company: "Neatflo",
            summary: "AI productivity tools",
            matchStrength: 0.9,
            timestamp: .now,
            profile: Profile(name: "Jess Wong", title: "CTO", company: "Neatflo", photo: "jess", raised: "$0", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
        ),
        Opportunity(
            title: "Engineer",
            company: "HealthAI",
            summary: "Healthcare innovation",
            matchStrength: 0.85,
            timestamp: .now,
            profile: Profile(name: "Dave Patel", title: "Engineer", company: "HealthAI", photo: "dave", raised: "$0", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
        ),
        Opportunity(
            title: "Designer",
            company: "EcoLoop",
            summary: "Sustainable design",
            matchStrength: 0.88,
            timestamp: .now,
            profile: Profile(name: "Zoe Li", title: "Designer", company: "EcoLoop", photo: "zoe", raised: "$0", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
        )
    ]

    func removeCard(profile: Profile, direction: SwipeCardView.SwipeDirection) {
        withAnimation {
            opportunities.removeAll { $0.profile.id == profile.id }
        }
    }

    var body: some View {
        ZStack {
            ForEach(opportunities.reversed(), id: \.id) { opportunity in
                SwipeCardView(profile: opportunity.profile) { profile, direction in
                    removeCard(profile: profile, direction: direction)
                }
            }
        }
        .padding()
    }
}

#Preview {
    if #available(iOS 17, *) {
        let sampleProfile = Profile(
            name: "Jess Wong",
            title: "CTO",
            company: "Neatflo",
            photo: "Jess Wong", // make sure this matches your Assets
            raised: "$1.2B",
            role: "Engineer",
            bio: "Building productivity tools with AI."
        )

        return SwipeCardView(profile: sampleProfile) { profile, direction in
            switch direction {
            case .left:
                print("User passed on \(profile.name)")
            case .right:
                print("User liked \(profile.name)")
            }
        }
    } else {
        return Text("iOS 17+ required")
    }
}





