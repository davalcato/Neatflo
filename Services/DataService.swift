//
//  DataService.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/3/25.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@MainActor
final class NeatfloDataService: NeatfloDataServiceProtocol {
    static let shared = NeatfloDataService()
    private let modelContext: ModelContext

    private init() {
        self.modelContext = ModelContext(Persistence.shared.container)
        seedInitialDataIfNeeded()
    }

    // MARK: - CRUD Operations

    func fetchOpportunities() async throws -> [Opportunity] {
        let descriptor = FetchDescriptor<Opportunity>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func addOpportunity(_ opportunity: Opportunity) async throws {
        modelContext.insert(opportunity)
        try modelContext.save()
    }

    func updateOpportunity(_ opportunity: Opportunity) async throws {
        try modelContext.save()
    }

    func deleteOpportunity(id: UUID) async throws {
        let descriptor = FetchDescriptor<Opportunity>(
            predicate: #Predicate { $0.uuid == id }
        )
        if let opportunity = try modelContext.fetch(descriptor).first {
            modelContext.delete(opportunity)
            try modelContext.save()
        }
    }

    // MARK: - Advanced Queries

    func fetchOpportunities(minMatchStrength: Double) async throws -> [Opportunity] {
        let descriptor = FetchDescriptor<Opportunity>(
            predicate: #Predicate { $0.matchStrength >= minMatchStrength },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetchRecentOpportunities(limit: Int) async throws -> [Opportunity] {
        var descriptor = FetchDescriptor<Opportunity>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return try modelContext.fetch(descriptor)
    }

    // MARK: - Private Helpers

    private func seedInitialDataIfNeeded() {
        let descriptor = FetchDescriptor<Opportunity>()
        guard (try? modelContext.fetch(descriptor).isEmpty) == true else { return }

        let sampleProfile = Profile(
            name: "Jordan Smith",
            title: "Investor",
            company: "CapitalX",
            photo: "jordan",
            raised: "$2.5M",
            role: "Investor",
            bio: "Active angel investor with a passion for early-stage startups."
        )

        let sampleOpportunities = [
            Opportunity(
                title: "Seed Investment",
                company: "Neatflo Ventures",
                summary: "Connect with investors for your startup",
                matchStrength: 0.92,
                timestamp: Date(),
                tags: ["Seed", "Investment", "Startup", "Fundraising"],
                profile: sampleProfile
            ),
            Opportunity(
                title: "Technical Partner",
                company: "Founder Network",
                summary: "Find your technical co-founder",
                matchStrength: 0.88,
                timestamp: Date().addingTimeInterval(-86400),
                tags: ["Co-Founder", "Tech", "Startup", "Networking"],
                profile: sampleProfile
            )
        ]

        sampleOpportunities.forEach { modelContext.insert($0) }
        try? modelContext.save()
    }
}

// MARK: - Global Persistence Struct

@available(iOS 17, *)
struct Persistence {
    static let shared = Persistence()
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: Opportunity.self, Profile.self,
                configurations: ModelConfiguration(
                    schema: Schema([Opportunity.self, Profile.self]),
                    isStoredInMemoryOnly: false
                )
            )
        } catch {
            print("⛔️ SwiftData model initialization failed: \(error)")
            fatalError("❌ Failed to initialize Neatflo's data storage: \(error)")
        }
    }
}


