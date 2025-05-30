//
//  ProfileCardView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import SwiftUI

@available(iOS 17, *)
struct ProfileCardView: View {
    let profiles: [Profile]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(profiles) { profile in
                    HStack(alignment: .top, spacing: 16) {
                        loadImage(named: profile.photo)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 4)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(profile.name)
                                .font(.title3)
                                .fontWeight(.semibold)

                            Text("\(profile.title) at \(profile.company)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            if profile.raised != "$0" {
                                Text("Raised: \(profile.raised)")
                                    .font(.footnote)
                                    .foregroundColor(.green)
                            }
                        }

                        Spacer()
                    }
                    .cardView()
                }
            }
            .padding()
        }
    }

    /// Loads an image from assets or uses a fallback system image
    private func loadImage(named name: String) -> Image {
        if let uiImage = UIImage(named: name) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.crop.circle.fill")
        }
    }
}

#Preview {
    if #available(iOS 17, *) {
        ProfileCardView(profiles: [
            Profile(name: "Jess Wong", title: "CTO", company: "Neatflo", photo: "Jess Wong", raised: "$5M", role: "Co-Founder", bio: "Tech lead at Neatflo."),
            Profile(name: "Sarah Kim", title: "Partner", company: "Future Fund", photo: "sarah", raised: "$30M", role: "Angel Investor", bio: "Invests in early-stage startups."),
            Profile(name: "Tom Lee", title: "Angel", company: "SkyInvest", photo: "tom", raised: "$10M", role: "Angel Investor", bio: "AI & web3 angel.")
        ])
    } else {
        // Fallback on earlier versions
    }
}






