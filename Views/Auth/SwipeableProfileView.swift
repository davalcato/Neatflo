//
//  SwipeableProfileView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/24/25.
//

import SwiftUI
import AVFoundation

@available(iOS 17, *)
struct SwipeableProfileView: View {
    let profiles: [Profile]
    @Environment(\.presentationMode) var presentationMode
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGSize = .zero
    @State private var dismissed: Bool = false
    @State private var showDetail: Bool = false
    @State private var selectedProfile: Profile?
    @State private var player: AVAudioPlayer?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ForEach(Array(profiles.enumerated().reversed()), id: \.1.id) { index, profile in
                if index >= currentIndex {
                    GeometryReader { geometry in
                        let isTopCard = index == currentIndex
                        let dragAmount = isTopCard ? dragOffset.width : 0
                        let maxDrag: CGFloat = 150
                        let iconOpacity = min(abs(dragAmount) / maxDrag, 1.0)
                        let rotationAngle = Angle(degrees: Double(dragAmount / 15))

                        ZStack {
                            Image(profile.photo)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.8)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                    .cornerRadius(20)
                                )
                                .offset(x: isTopCard ? dragOffset.width : 0, y: isTopCard ? dragOffset.height : CGFloat(index - currentIndex) * 10)
                                .rotation3DEffect(isTopCard ? rotationAngle : .zero, axis: (x: 0, y: 1, z: 0))
                                .scaleEffect(dismissed && isTopCard ? 0.3 : (isTopCard ? 1.0 : 0.95))
                                .opacity(dismissed && isTopCard ? 0 : 1)
                                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: dragOffset)
                                .animation(.easeOut(duration: 0.3), value: dismissed)
                                .onTapGesture {
                                    selectedProfile = profile
                                    showDetail = true
                                }
                                .gesture(
                                    isTopCard ? DragGesture()
                                        .onChanged { value in
                                            dragOffset = value.translation
                                        }
                                        .onEnded { value in
                                            let threshold: CGFloat = 100
                                            withAnimation(.spring()) {
                                                if value.translation.width < -threshold && currentIndex < profiles.count - 1 {
                                                    playSound()
                                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                    dismissed = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                        currentIndex += 1
                                                        dragOffset = .zero
                                                        dismissed = false
                                                    }
                                                } else if value.translation.width > threshold && currentIndex > 0 {
                                                    playSound()
                                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                    currentIndex -= 1
                                                    dragOffset = .zero
                                                } else {
                                                    dragOffset = .zero
                                                }
                                            }
                                        }
                                    : nil
                                )

                            if isTopCard && abs(dragOffset.width) > 20 {
                                Image(systemName: dragOffset.width > 0 ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding()
                                    .background(dragOffset.width > 0 ? Color.green : Color.red)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .offset(dragOffset)
                                    .opacity(iconOpacity)
                                    .animation(.easeInOut, value: dragOffset)
                            }

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
                        .zIndex(Double(profiles.count - index))
                    }
                }
            }

            // Back Button
            VStack {
                HStack {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Label("Back", systemImage: "chevron.left")
//                            .foregroundColor(.white)
//                            .padding(10)
//                            .background(.ultraThinMaterial)
//                            .clipShape(Capsule())
//                    }
                    Spacer()
                }
                .padding(.top, 50)
                .padding(.horizontal)
                Spacer()
            }
        }
        .fullScreenCover(item: $selectedProfile) { profile in
            ProfileDetailView(profile: profile)
        }
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "flip", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Sound playback failed")
        }
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

