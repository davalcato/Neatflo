//
//  NeatfloDataManager.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/27/25.
//

import Foundation
import SwiftData

// MARK: - Neatflo Data Manager (Replaces FirestoreManager)
@available(iOS 17, *)
final class NeatfloDataManager {
    static let shared = NeatfloDataManager()
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init() {
        do {
            // 1. Define schema
            let schema = Schema([Opportunity.self])
            
            // 2. Create configuration - MOVED OUTSIDE OF AVAILABILITY CHECK
            let config = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            
            // 3. Initialize container
            modelContainer = try ModelContainer(
                for: schema,
                configurations: config
            )
            
            modelContext = ModelContext(modelContainer)
            
        } catch {
            fatalError("Failed to initialize Neatflo data storage: \(error)")
        }
    }
    
    // MARK: - Fetch Opportunities
    func fetchOpportunities(completion: @escaping ([Opportunity]?, Error?) -> Void) {
        do {
            let descriptor = FetchDescriptor<Opportunity>(
                sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
            )
            let opportunities = try modelContext.fetch(descriptor)
            
            if opportunities.isEmpty {
                // Insert mock data on first launch
                insertMockOpportunities()
                let refreshed = try modelContext.fetch(descriptor)
                completion(refreshed, nil)
            } else {
                completion(opportunities, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    // MARK: - Add New Opportunity
    func addOpportunity(_ opportunity: Opportunity, completion: @escaping (Error?) -> Void) {
        modelContext.insert(opportunity)
        do {
            try modelContext.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    // MARK: - Private Helpers
    private func insertMockOpportunities() {
        let mockProfile = Profile(
            name: "Taylor Reid",
            title: "Startup Mentor",
            company: "Seed Ventures",
            photo: "taylor", // Ensure this image is in your asset catalog
            raised: "$2M",
            role: "Advisor",
            bio: "Experienced startup mentor and early-stage investor."
        )
        
        let mockOpportunities = [
            Opportunity(
                title: "Investor Introduction",
                company: "Seed Ventures",
                summary: "Connect with angel investors in your industry",
                matchStrength: 0.85,
                timestamp: Date(),
                profile: mockProfile
            ),
            Opportunity(
                title: "Co-Founder Match",
                company: "Founder Network",
                summary: "Meet potential technical co-founders",
                matchStrength: 0.92,
                timestamp: Date().addingTimeInterval(-86400),
                profile: mockProfile
            )
        ]
        
        mockOpportunities.forEach { modelContext.insert($0) }
    }
}

