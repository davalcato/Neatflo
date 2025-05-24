//
//  SwipeableProfileView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/24/25.
//

import SwiftUI

struct SwipeableProfileView: View {
    let profiles: [Profile]
    @State private var currentIndex: Int = 0

    var body: some View {
            TabView {
                ForEach(profiles) { profile in
                    VStack(spacing: 16) {
                        Image(profile.photo)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        Text(profile.name)
                            .font(.title)
                            .bold()

                        Text("\(profile.title) at \(profile.company)")
                            .font(.subheadline)

                        Text("Raised: \(profile.raised)")
                            .font(.subheadline)

                        Text(profile.bio)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .navigationTitle("Profile")
        }
    }

    private func profileCard(for profile: Profile) -> some View {
        ZStack(alignment: .bottomLeading) {
            profileImage(named: profile.photo)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(profile.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("\(profile.title) at \(profile.company)")
                    .font(.headline)
                    .foregroundColor(.white)

                Text(profile.bio)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.top, 2)
            }
            .padding()
            .background(Color.black.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 10))

        }
        .cornerRadius(20)
        .shadow(radius: 10)
    }

    private func profileImage(named name: String) -> Image {
        if let uiImage = UIImage(named: name) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.crop.circle.fill")
        }
    }

#Preview {
    SwipeableProfileView(profiles: [
        Profile(
            name: "Jess Wong",
            title: "CTO",
            company: "Neatflo",
            photo: "Jess Wong",
            raised: "$5M",
            role: "Co-Founder",
            bio: "Tech lead at Neatflo."
        ),
        Profile(
            name: "Dave Patel",
            title: "CEO",
            company: "StartIQ",
            photo: "Dave Patel",
            raised: "$12M",
            role: "Co-Founder",
            bio: "Serial founder and operator."
        ),
        Profile(
            name: "Zoe Li",
            title: "CMO",
            company: "Glow",
            photo: "Zoe Li",
            raised: "$3M",
            role: "Co-Founder",
            bio: "Growth marketing expert."
        )
    ])
}

