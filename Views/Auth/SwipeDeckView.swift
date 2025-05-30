//
//  SwipeDeckView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/28/25.
//

import SwiftUI

@available(iOS 17, *)
struct SwipeDeckView: View {
    @State private var profiles: [Profile] = [
        Profile(
            name: "Jess Wong",
            title: "CTO",
            company: "Neatflo",
            photo: "sample_photo1",
            raised: "$1.2B",
            role: "Engineer",
            bio: "Building productivity tools with AI."
        ),
        Profile(
            name: "Marcus Lee",
            title: "CEO",
            company: "Visionary Inc.",
            photo: "sample_photo2",
            raised: "$950M",
            role: "Leader",
            bio: "Driving innovation in augmented reality."
        )
    ]

    var body: some View {
        ZStack {
            ForEach(profiles.reversed(), id: \.id) { profile in
                SwipeCardView(profile: profile) { removedProfile, direction in
                    handleSwipe(profile: removedProfile, direction: direction)
                }
            }
        }
        .padding()
    }

    private func handleSwipe(profile: Profile, direction: SwipeCardView.SwipeDirection) {
        profiles.removeAll { $0.id == profile.id }
        print("Swiped \(direction == .right ? "Right" : "Left") on \(profile.name)")
    }
}


#Preview {
    if #available(iOS 17.0, *) {
        SwipeDeckView()
    } else {
        Text("Requires iOS 17+")
    }
}


