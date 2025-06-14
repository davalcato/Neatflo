//
//  OpportunitiesViewModel.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/3/25.
//

import Foundation

@available(iOS 17, *)
@MainActor
class OpportunitiesViewModel: ObservableObject {
    @Published var opportunities: [Opportunity] = []
    @Published var isLoading: Bool = false

    func fetchOpportunities() {
        isLoading = true

        // Simulate async data fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.opportunities = [
                Opportunity(
                    title: "Seed Funding",
                    company: "Neatflo Ventures",
                    summary: "AI-powered workflow automation",
                    matchStrength: 0.87,
                    timestamp: Date(),
                    tags: ["AI", "Automation", "Seed"],
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
                    title: "Co-Founder Needed",
                    company: "EyeAeon",
                    summary: "Building AI detection layers for mobile apps",
                    matchStrength: 0.92,
                    timestamp: Date(),
                    tags: ["AI", "Mobile", "Co-Founder"],
                    profile: Profile(
                        name: "David Alvarez",
                        title: "Founder",
                        company: "EyeAeon",
                        photo: "david",
                        raised: "$500K",
                        role: "Founder",
                        bio: "Visionary behind AI-powered detection for everyday users."
                    )
                )
            ]
            self.isLoading = false
        }
    }
}




