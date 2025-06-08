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
            VStack(spacing: 20) {
                // 💡 Clever Title with Gradient and Emoji
                Text("💼 AI-Matched Investors")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [.white, .yellow],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                    .padding(.top)

                ForEach(profiles, id: \.id) { profile in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            // 👤 Custom image if profile is Sarah Kim
                            if profile.name == "Sarah Kim" {
                                Image("sarah_kim")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            } else {
                                Image(profile.photo)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(profile.name)
                                    .font(.title3.bold())
                                Text(profile.title + " @ " + profile.company)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }

                        Text(profile.bio)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineLimit(3)

                        HStack {
                            Label("Raised: \(profile.raised)", systemImage: "chart.bar.fill")
                                .font(.footnote)
                                .foregroundColor(.blue)
                            Spacer()
                            Label(profile.role, systemImage: "person.crop.circle.fill")
                                .font(.footnote)
                                .foregroundColor(.purple)
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(colors: [.white, .blue.opacity(0.1)],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .background(
            LinearGradient(colors: [Color.purple.opacity(0.25),
                                    Color.blue.opacity(0.2),
                                    Color.pink.opacity(0.25)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
        )
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






