//
//  FeedViewModel.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

// FeedViewModel.swift
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
                sortBy: [SortDescriptor(\Opportunity.timestamp, order: .reverse)]
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

    private func seedSampleData() async {
        let sampleProfile = Profile(
            name: "Alex Johnson",
            title: "Angel Investor",
            company: "Neatflo Network",
            photo: "alex",
            raised: "$5M",
            role: "Investor",
            bio: "Focuses on early-stage startups in tech and health sectors."
        )

        let sampleOpportunities = [
            Opportunity(
                title: "Investor Introduction",
                company: "Neatflo Network",
                summary: "Connect with angel investors interested in your sector",
                matchStrength: 0.87,
                timestamp: Date(),
                tags: ["Angel", "HealthTech", "Seed Funding", "Pitch"],
                profile: sampleProfile
            ),
            Opportunity(
                title: "Co-Founder Match",
                company: "Founder Hub",
                summary: "Meet potential technical co-founders with complementary skills",
                matchStrength: 0.92,
                timestamp: Date().addingTimeInterval(-86400),
                tags: ["Co-Founder", "Tech", "Networking", "Startup"],
                profile: sampleProfile
            )
        ]

        sampleOpportunities.forEach { modelContext.insert($0) }
        try? modelContext.save()
    }
}




