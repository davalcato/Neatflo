//
//  FeedViewModel.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
@MainActor
final class FeedViewModel: ObservableObject {
    @Published var opportunities: [Opportunity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task {
            await loadOpportunities()
        }
    }
    
    func loadOpportunities() async {
        isLoading = true
        do {
            let descriptor = FetchDescriptor<Opportunity>(
                sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
            )
            opportunities = try modelContext.fetch(descriptor)
            
            if opportunities.isEmpty {
                await seedSampleData()
                opportunities = try modelContext.fetch(descriptor)
            }
            
            isLoading = false
        } catch {
            errorMessage = "Failed to load opportunities"
            isLoading = false
        }
    }
    
    func refresh() async {
        await loadOpportunities()
    }
    
    @available(iOS 17, *)
    private func seedSampleData() async {
        let sampleProfile = Profile(
            name: "Alex Johnson",
            title: "Angel Investor",
            company: "Neatflo Network",
            photo: "alex", // ensure this image asset exists
            raised: "$5M",
            role: "Investor",
            bio: "Focuses on early-stage startups in tech and health sectors."
        )
        
        let sampleOpportunities = [
            Opportunity(
                title: "Investor Introduction",
                company: "Neatflo Network",
                summary: "Connect with angel investors interested in your sector",
                matchStrength: 87,
                timestamp: Date(),
                profile: sampleProfile
            ),
            Opportunity(
                title: "Co-Founder Match",
                company: "Founder Hub",
                summary: "Meet potential technical co-founders with complementary skills",
                matchStrength: 92,
                timestamp: Date().addingTimeInterval(-86400),
                profile: sampleProfile
            )
        ]
        
        sampleOpportunities.forEach { modelContext.insert($0) }
        try? modelContext.save()
    }
}
