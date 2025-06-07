//
//  OpportunityCard.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/19/25.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
struct OpportunityCard<Destination: View>: View {
    let opportunity: Opportunity
    let destination: () -> Destination

    @State private var isPressed = false
    @State private var navigate = false

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

            Text(opportunity.summary)
                .font(.footnote)
                .foregroundColor(.secondary)

            // Tag Chips
            if !opportunity.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(opportunity.tags, id: \.self) { tag in
                            TagButton(tag: tag)
                        }
                    }
                    .padding(.top, 4)
                }
            }

            HStack {
                if opportunity.matchStrength > 0 {
                    VStack {
                        Text("Match")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text("\(Int(opportunity.matchStrength * 100))%")
                            .font(.headline)
                            .foregroundColor(opportunity.matchStrength > 0.8 ? .green : .orange)
                    }
                }

                Spacer()

                Button(action: {
                    print("Tapped on: \(opportunity.title)")
                    navigate = true
                }) {
                    Text("View Details")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isPressed ? Color.blue.opacity(0.7) : Color.blue)
                        .cornerRadius(8)
                        .scaleEffect(isPressed ? 0.97 : 1.0)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.01)
                        .onChanged { _ in
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isPressed = false
                            }
                        }
                )

                NavigationLink(destination: destination(), isActive: $navigate) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 6)
    }
}


// MARK: - Preview
@available(iOS 17.0, *)
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Opportunity.self,
        configurations: config
    )
    
    let profile = Profile(
        name: "Jess Wong",
        title: "CTO",
        company: "Neatflo",
        photo: "Jess Wong",
        raised: "$1.2B",
        role: "Engineer",
        bio: "Building productivity tools with AI."
    )
    
    let opportunity = Opportunity(
        title: "Seed Funding",
        company: "Neatflo",
        summary: "AI for business",
        matchStrength: 0.92,
        timestamp: Date(),
        tags: ["AI", "Seed", "B2B", "Tech", "Productivity"],
        profile: profile
    )
    
    return OpportunityCard(
        opportunity: opportunity,
        destination: {
            Text("Preview Destination")
        }
    )
    .padding()
    .modelContainer(container)
}








