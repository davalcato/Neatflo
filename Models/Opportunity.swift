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
    @Attribute(.unique)
    var id: UUID

    var title: String
    var company: String
    var location: String?
    var summary: String
    var matchStrength: Double
    var timestamp: Date

    // ✅ Declaring a relationship to Profile
    @Relationship
    var profile: Profile

    init(title: String, company: String, location: String? = nil,
         summary: String, matchStrength: Double, timestamp: Date, profile: Profile) {
        self.id = UUID()
        self.title = title
        self.company = company
        self.location = location
        self.summary = summary
        self.matchStrength = matchStrength
        self.timestamp = timestamp
        self.profile = profile
    }
}



// MARK: - Migration Helpers (fileprivate scope)
fileprivate struct OldOpportunity: Codable {
    let id: UUID
    let title: String
    let company: String
    let summary: String
    let matchStrength: Double
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id, title, company
        case summary = "description"
        case matchStrength, timestamp
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
            profile: profile
        )
    }

    static func from(jsonData: Data) throws -> Opportunity {
        if #available(iOS 17, *) {
            let old = try JSONDecoder().decode(OldOpportunity.self, from: jsonData)
            let profile = matchProfile(for: old.company)
            
            return Opportunity(
                title: old.title,
                company: old.company,
                summary: old.summary,
                matchStrength: old.matchStrength,
                timestamp: old.timestamp,
                profile: profile
            )
        } else {
            throw NSError(
                domain: "NeatfloErrorDomain",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "SwiftData requires iOS 17+"]
            )
        }
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



