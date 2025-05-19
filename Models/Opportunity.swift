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
final class Opportunity {
    @Attribute(.unique) var id: UUID
    var title: String
    var company: String
    var summary: String
    var matchStrength: Double
    var timestamp: Date
    
    init(title: String, company: String, summary: String,
         matchStrength: Double, timestamp: Date) {
        self.id = UUID()
        self.title = title
        self.company = company
        self.summary = summary
        self.matchStrength = matchStrength
        self.timestamp = timestamp
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
        // No availability check needed - whole extension is iOS 17+
        Opportunity(
            title: old.title,
            company: old.company,
            summary: old.summary,
            matchStrength: old.matchStrength,
            timestamp: old.timestamp
        )
    }
    
    static func from(jsonData: Data) throws -> Opportunity {
        if #available(iOS 17, *) {
            let old = try JSONDecoder().decode(OldOpportunity.self, from: jsonData)
            return Opportunity(
                title: old.title,
                company: old.company,
                summary: old.summary,
                matchStrength: old.matchStrength,
                timestamp: old.timestamp
            )
        } else {
            // For pre-iOS 17, throw explicit error
            throw NSError(
                domain: "NeatfloErrorDomain",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "SwiftData requires iOS 17+"]
            )
        }
    }
}


