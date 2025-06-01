//
//  Opportunity.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

// Opportunity.swift

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
final class Opportunity: Identifiable {
    @Attribute(.unique) var uuid: UUID
    var title: String
    var company: String
    var location: String?
    var summary: String
    var matchStrength: Double
    var timestamp: Date
    var tags: [String]
    
    @Relationship
    var profile: Profile
    
    init(title: String, company: String, location: String? = nil,
         summary: String, matchStrength: Double = 0,
         timestamp: Date, tags: [String], profile: Profile) {
        
        self.uuid = UUID() // ✅ Set uuid
        self.title = title
        self.company = company
        self.location = location
        self.summary = summary
        self.matchStrength = matchStrength
        self.timestamp = timestamp
        self.tags = tags
        self.profile = profile
    }
}


// MARK: - User Preferences Model

struct UserPreferences {
    let interests: [String]
    let preferredIndustries: [String]
}

// MARK: - Match Scoring Logic

@available(iOS 17, *)
extension Opportunity {
    static func calculateMatchScore(user: UserPreferences, opportunity: Opportunity) -> Double {
        var score = 0.0

        // Keyword match scoring
        for tag in opportunity.tags {
            if user.interests.contains(where: { $0.lowercased() == tag.lowercased() }) {
                score += 20
            }
            if user.preferredIndustries.contains(where: { $0.lowercased() == tag.lowercased() }) {
                score += 15
            }
        }

        // Recency scoring
        let daysAgo = Calendar.current.dateComponents([.day], from: opportunity.timestamp, to: Date()).day ?? 0
        if daysAgo <= 1 {
            score += 15
        } else if daysAgo <= 3 {
            score += 10
        } else if daysAgo <= 7 {
            score += 5
        }

        return min(score, 100)
    }
}

// MARK: - Migration Helpers

fileprivate struct OldOpportunity: Codable {
    let id: UUID
    let title: String
    let company: String
    let summary: String
    let matchStrength: Double
    let timestamp: Date
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, title, company, summary, matchStrength, timestamp, tags
    }
}

@available(iOS 17, *)
extension Opportunity {
    fileprivate static func from(_ old: OldOpportunity) -> Opportunity {
        let profile = matchProfile(for: old.company)
        return Opportunity(
            title: old.title,
            company: old.company,
            summary: old.summary,
            matchStrength: old.matchStrength,
            timestamp: old.timestamp,
            tags: old.tags,
            profile: profile
        )
    }
    
    static func from(jsonData: Data) throws -> [Opportunity] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try decoder.decode([OldOpportunity].self, from: jsonData)
        
        return decoded.map { from($0) }
    }
    
    static func matchProfile(for company: String) -> Profile {
        switch company {
        case "Future Fund":
            return Profile(name: "Sarah Kim", title: "Partner", company: "Future Fund", photo: "sarah", raised: "$30M", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
        case "SkyInvest":
            return Profile(name: "Tom Lee", title: "Angel", company: "SkyInvest", photo: "tom", raised: "$10M", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
        case "NextGen Capital":
            return Profile(name: "Nina Rao", title: "Principal", company: "NextGen Capital", photo: "nina", raised: "$50M", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
        case "Neatflo":
            return Profile(name: "Jess Wong", title: "CTO", company: "Neatflo", photo: "jess", raised: "$0", role: "Engineer", bio: "Building productivity tools with AI.")
        case "HealthAI":
            return Profile(name: "Dave Patel", title: "Engineer", company: "HealthAI", photo: "dave", raised: "$0", role: "Engineer", bio: "Focuses on AI-powered healthcare solutions.")
        case "EcoLoop":
            return Profile(name: "Zoe Li", title: "Designer", company: "EcoLoop", photo: "zoe", raised: "$0", role: "Designer", bio: "Passionate about sustainable design.")
        default:
            return Profile(name: "Unknown", title: "", company: company, photo: "", raised: "$0", role: "", bio: "")
        }
    }
}




