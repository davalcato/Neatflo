//
//  ProfileCardView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import SwiftUI

struct ProfileCardView: View {
    let profiles: [Profile]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(profiles) { profile in
                    HStack(alignment: .top, spacing: 16) {
                        Image(profile.photo)
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
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
    }
}


#Preview {
    ProfileCardView(profiles: [
        Profile(name: "Sarah Kim", title: "Partner", company: "Future Fund", photo: "sarah", raised: "$30M", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Tom Lee", title: "Angel", company: "SkyInvest", photo: "tom", raised: "$10M", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
    ])
}


