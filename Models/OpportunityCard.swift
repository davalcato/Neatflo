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

            HStack {
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

                // ✅ NavigationLink triggered only from button
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





