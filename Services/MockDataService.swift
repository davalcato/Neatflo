//
//  MockDataService.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/4/25.
//

import Foundation

@available(iOS 17, *)
class MockDataService: ObservableObject {
    @Published var opportunities: [Opportunity] = [
        Opportunity(
            title: "Sample Opportunity",
            company: "Test Company",
            summary: "Preview data for iOS 16",
            matchStrength: 0.8,
            timestamp: Date(),
            tags: ["Startup", "Investor", "Demo", "iOS"],
            profile: Profile(
                name: "Jess Wong",
                title: "Investor",
                company: "CapitalX",
                photo: "Jess Wong", // Ensure this image exists in Assets
                raised: "$1.5M",
                role: "Investor",
                bio: "Tech investor focused on early-stage startups."
            )
        )
    ]
    
    func fetchOpportunities() -> [Opportunity] {
        return opportunities
    }
}


