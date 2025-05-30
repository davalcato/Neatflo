//
//  SwipeableProfileView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/24/25.
//

import SwiftUI
import UIKit

@available(iOS 17, *)
struct SwipeableProfileView: View {
    let profiles: [Profile]
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(profiles.enumerated()), id: \.1.id) { index, profile in
                GeometryReader { geometry in
                    ZStack {
                        // Background Image
                        Image(profile.photo)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .cornerRadius(20)
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]),
                                    startPoint: .bottom,
                                    endPoint: .center
                                )
                                .cornerRadius(20)
                            )
                            .offset(dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        let threshold: CGFloat = 100
                                        let generator = UIImpactFeedbackGenerator(style: .medium)

                                        withAnimation(.spring()) {
                                            if value.translation.width < -threshold && currentIndex < profiles.count - 1 {
                                                currentIndex += 1
                                                generator.impactOccurred()
                                            } else if value.translation.width > threshold && currentIndex > 0 {
                                                currentIndex -= 1
                                                generator.impactOccurred()
                                            }
                                            dragOffset = .zero
                                        }
                                    }
                            )
                            .animation(.easeInOut, value: dragOffset)

                        // Conditional Thumbs Icon
                        ZStack {
                            if abs(dragOffset.width) > 20 {
                                Image(systemName: dragOffset.width > 0 ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding()
                                    .background(dragOffset.width > 0 ? Color.green : Color.red)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .offset(dragOffset)
                                    .transition(.scale)
                                    .animation(.easeInOut, value: dragOffset)
                            }
                        }

                        // Text content at bottom left
                        VStack(alignment: .leading, spacing: 4) {
                            Spacer()
                            Text(profile.name)
                                .font(.title)
                                .bold()

                            Text("\(profile.title) at \(profile.company)")
                                .font(.subheadline)

                            Text("Raised: \(profile.raised)")
                                .font(.subheadline)

                            Text(profile.bio)
                                .font(.body)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .padding(.vertical)
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .navigationTitle("Profile")
    }
}



@available(iOS 17, *)
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
    if #available(iOS 17, *) {
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
    } else {
        // Fallback on earlier versions
    }
}

