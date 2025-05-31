//
//  ProfileDetailView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/30/25.
//

import SwiftUI

@available(iOS 17, *)
struct ProfileDetailView: View {
    let profile: Profile
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(profile.photo)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()

                Text(profile.name)
                    .font(.largeTitle)
                    .bold()

                Text(profile.title + " at " + profile.company)
                    .font(.headline)

                Text("Raised: \(profile.raised)")
                    .font(.subheadline)

                Text(profile.bio)
                    .font(.body)

                Spacer()
            }
            .padding()
        }
        .overlay(
            HStack {
                Button("Close") {
                    dismiss()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .clipShape(Capsule())
                Spacer()
            }
            .padding(.top, 50)
            .padding(.horizontal),
            alignment: .top
        )
    }
}


#Preview {
    if #available(iOS 17, *) {
        ProfileDetailView(profile: Profile(
            name: "Jane Doe",
            title: "CEO",
            company: "Neatflo",
            photo: "profile_photo_sample",
            raised: "$2.5M",
            role: "Founder",
            bio: "Visionary founder focused on AI innovation and UX design."
        ))
    } else {
        Text("iOS 17+ required")
    }
}

