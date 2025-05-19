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
            timestamp: Date()
        )
    ]
    
    func fetchOpportunities() -> [Opportunity] {
        return opportunities
    }
}
