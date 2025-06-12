//
//  OpportunityTagsView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 6/11/25.
//

// OpportunityTagsView.swift
import SwiftUI

@available(iOS 17.0, *)
struct OpportunityTagsView: View {
    let tags: [String]
    let onTagTap: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Button(action: {
                        onTagTap(tag)
                    }) {
                        Text(tag)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
}


#Preview {
    if #available(iOS 17, *) {
        OpportunityTagsView(
            tags: ["Angel", "HealthTech", "Seed Funding", "Pitch"],
            onTagTap: { tag in
                print("Tag tapped: \(tag)")
            }
        )
    } else {
        // Fallback on earlier versions
    }
}

