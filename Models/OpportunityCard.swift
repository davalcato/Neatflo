//
//  OpportunityCard.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/19/25.
//

import SwiftUI

@available(iOS 17, *)
struct OpportunityCard: View {
    let opportunity: Opportunity

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "briefcase.fill")
                    .foregroundColor(.accentColor)
                Text(opportunity.title)
                    .font(.headline)
            }

            Text(opportunity.company)
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let location = opportunity.location {
                Label(location, systemImage: "mappin.and.ellipse")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            HStack {
                Spacer()
                Button("View Details") {
                    // Add navigation or detail logic here
                }
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.accentColor)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 6)
    }
}

#Preview {
    if #available(iOS 17, *) {
        OpportunityCard(opportunity: Opportunity(
            title: "Seed Funding",
            company: "Neatflo Ventures",
            summary: "AI for business automation",
            matchStrength: 0.92,
            timestamp: Date()
        ))
    } else {
        // Fallback on earlier versions
    }
}
