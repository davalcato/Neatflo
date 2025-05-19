//
//  DataService.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/3/25.
//

import Foundation
import SwiftData
import Combine

@available(iOS 17, *)
@MainActor
final class NeatfloDataService: NeatfloDataServiceProtocol {
    static let shared = NeatfloDataService()
    private let modelContext: ModelContext
    
    private init() {
        self.modelContext = ModelContext(Persistence.shared.container)
        seedInitialDataIfNeeded()
    }
    
    // MARK: - Core Methods
    
    func fetchOpportunities() async throws -> [Opportunity] {
        let descriptor = FetchDescriptor<Opportunity>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    // MARK: - CRUD Operations
    
    func addOpportunity(_ opportunity: Opportunity) async throws {
        modelContext.insert(opportunity)
        try modelContext.save()
    }
    
    func updateOpportunity(_ opportunity: Opportunity) async throws {
        try modelContext.save()
    }
    
    func deleteOpportunity(id: UUID) async throws {
        let descriptor = FetchDescriptor<Opportunity>(
            predicate: #Predicate { $0.id == id }
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
        // Check if we already have data
        let descriptor = FetchDescriptor<Opportunity>()
        guard (try? modelContext.fetch(descriptor).isEmpty) == true else { return }
        
        // Create sample data
        let sampleOpportunities = [
            Opportunity(
                title: "Seed Investment",
                company: "Neatflo Ventures",
                summary: "Connect with investors for your startup",
                matchStrength: 0.92,
                timestamp: Date()
            ),
            Opportunity(
                title: "Technical Partner",
                company: "Founder Network",
                summary: "Find your technical co-founder",
                matchStrength: 0.88,
                timestamp: Date().addingTimeInterval(-86400)
            )
        ]
        
        // Insert and save
        sampleOpportunities.forEach { modelContext.insert($0) }
        try? modelContext.save()
    }
}

// MARK: - Persistence Configuration
@available(iOS 17, *)
struct Persistence {
    static let shared = Persistence()
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(
                for: Opportunity.self,
                configurations: ModelConfiguration(
                    schema: Schema([Opportunity.self]),
                    isStoredInMemoryOnly: false
                )
            )
        } catch {
            fatalError("Failed to configure Neatflo persistence: \(error)")
        }
    }
}
