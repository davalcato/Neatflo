//
//  OpportunityCard.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/19/25.
//

import SwiftUI

@available(iOS 17, *)
struct OpportunityCard<Destination: View>: View {
    let opportunity: Opportunity
    let destination: () -> Destination
    @State private var isPressed = false

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

            HStack {
                Spacer()
                NavigationLink(destination: destination()) {
                    Text("View Details")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .animation(.easeOut(duration: 0.15), value: isPressed)
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed = true }
                        .onEnded { _ in isPressed = false }
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 6)
    }
}


@available(iOS 17.0, *)
#Preview {
    OpportunityCard(
        opportunity: Opportunity(
            title: "Seed Funding",
            company: "Neatflo Ventures",
            summary: "AI for business automation",
            matchStrength: 0.92,
            timestamp: Date()
        ),
        destination: {
            Text("Preview Destination")
        }
    )
    .padding()
}





