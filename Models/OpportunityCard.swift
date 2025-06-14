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
            HStack(spacing: 12) {
                Image(systemName: "briefcase.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(opportunity.title)
                        .font(.title3.bold())
                    
                    Text(opportunity.company)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Text("Match")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("\(Int(opportunity.matchStrength * 100))%")
                        .font(.headline)
                        .foregroundColor(opportunity.matchStrength > 0.8 ? .green : .orange)
                }
            }
            
            if let location = opportunity.location {
                Label(location, systemImage: "mappin.and.ellipse")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Text(opportunity.summary)
                .font(.footnote)
                .foregroundColor(.primary)
                .padding(.top, 2)
            
            if !opportunity.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(opportunity.tags, id: \.self) { tag in
                            TagButton(tag: tag)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .padding(.top, 6)
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    navigate = true
                }) {
                    Text("View Details")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(isPressed ? Color.blue.opacity(0.8) : Color.blue)
                        .cornerRadius(10)
                        .scaleEffect(isPressed ? 0.96 : 1.0)
                        .shadow(radius: isPressed ? 1 : 4)
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
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(radius: 10)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
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








