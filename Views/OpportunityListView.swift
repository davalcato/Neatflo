//
//  OpportunityListView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/27/25.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct OpportunityListView: View {
    @Environment(\.modelContext) private var context
    @State private var opportunities: [Opportunity] = []
    
    var body: some View {
        List(opportunities) { opportunity in
            OpportunityRow(opportunity: opportunity)
        }
        .task {
            await loadOpportunities()
        }
        .refreshable {
            await loadOpportunities()
        }
    }
    
    private func loadOpportunities() async {
        do {
            opportunities = try await NeatfloDataService.shared.fetchOpportunities()
        } catch {
            opportunities = []
            print("Error loading opportunities: \(error.localizedDescription)")
        }
    }
}

// MARK: - Opportunity Row View
@available(iOS 17, *)
struct OpportunityRow: View {
    let opportunity: Opportunity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(opportunity.title)
                        .font(.headline)
                    Text(opportunity.company)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("\(Int(opportunity.matchStrength * 100))%")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(matchStrengthColor)
            }
            
            Text(opportunity.summary)
                .font(.body)
                .lineLimit(2)
            
            Text(opportunity.timestamp, style: .relative)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 8)
    }
    
    private var matchStrengthColor: Color {
        switch opportunity.matchStrength {
        case 0.8...1.0: return .green
        case 0.6..<0.8: return .orange
        default: return .red
        }
    }
}

// MARK: - Preview
#Preview {
    if #available(iOS 17, *) {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: Opportunity.self,
                configurations: config
            )

            let testProfile = Profile(
                name: "Taylor Reid",
                title: "Startup Mentor",
                company: "Seed Ventures",
                photo: "taylor",
                raised: "$2M",
                role: "Advisor",
                bio: "Experienced startup mentor and early-stage investor."
            )

            let testOpportunity = Opportunity(
                title: "Seed Funding",
                company: "Neatflo Ventures",
                summary: "Preview opportunity data",
                matchStrength: 0.85,
                timestamp: Date(),
                profile: testProfile
            )

            container.mainContext.insert(testOpportunity)

            return OpportunityListView()
                .modelContainer(container)
        } catch {
            return Text("Failed to set up preview: \(error.localizedDescription)")
                .foregroundColor(.red)
        }
    } else {
        return Text("Preview requires iOS 17+")
    }
}


