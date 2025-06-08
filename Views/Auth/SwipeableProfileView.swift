//
//  SwipeableProfileView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/24/25.
//

import SwiftUI
import AVFoundation

@available(iOS 17.0, *)
struct SwipeableProfileView: View {
    @State var profiles: [Profile]
    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var dismissed = false
    @State private var showCompletion = false
    @State private var selectedProfile: Profile?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.purple.opacity(0.85), .blue.opacity(0.85)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Meet Your Match")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top, 10)

                    Spacer()

                    ZStack {
                        if currentIndex < profiles.count {
                            ForEach(Array(profiles.enumerated().reversed()), id: \.1.id) { index, profile in
                                if index >= currentIndex {
                                    GeometryReader { geometry in
                                        let isTopCard = index == currentIndex
                                        let dragAmount = isTopCard ? dragOffset.width : 0
                                        let maxDrag: CGFloat = 150
                                        let iconOpacity = min(abs(dragAmount) / maxDrag, 1.0)
                                        let rotationAngle = Angle(degrees: Double(dragAmount / 15))

                                        ZStack {
                                            // Background image
                                            Image(profile.photo)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.75)
                                                .clipped()
                                                .cornerRadius(24)
                                                .shadow(radius: 12)
                                                .overlay(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.black.opacity(0.65), Color.clear]),
                                                        startPoint: .bottom,
                                                        endPoint: .top
                                                    )
                                                    .cornerRadius(24)
                                                )
                                                .offset(x: isTopCard ? dragOffset.width : 0,
                                                        y: isTopCard ? dragOffset.height : CGFloat(index - currentIndex) * 10)
                                                .rotation3DEffect(isTopCard ? rotationAngle : .zero, axis: (x: 0, y: 1, z: 0))
                                                .scaleEffect(dismissed && isTopCard ? 0.3 : (isTopCard ? 1.0 : 0.95))
                                                .opacity(dismissed && isTopCard ? 0 : 1)
                                                .onTapGesture {
                                                    selectedProfile = profile
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
                                                                    dismissed = true
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                                        currentIndex += 1
                                                                        dragOffset = .zero
                                                                        dismissed = false

                                                                        if currentIndex == profiles.count - 1 {
                                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                                                showCompletion = true
                                                                            }
                                                                        }
                                                                    }
                                                                } else if value.translation.width > threshold && currentIndex > 0 {
                                                                    currentIndex -= 1
                                                                    dragOffset = .zero
                                                                } else {
                                                                    dragOffset = .zero
                                                                }
                                                            }
                                                        }
                                                    : nil
                                                )

                                            // Swipe indicators
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

                                            // Profile info overlay
                                            VStack(alignment: .leading, spacing: 6) {
                                                Spacer()

                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(profile.name)
                                                        .font(.title2.bold())
                                                        .foregroundColor(.white)

                                                    Text("\(profile.title) at \(profile.company)")
                                                        .font(.subheadline)
                                                        .foregroundColor(.white.opacity(0.9))

                                                    Text("Raised: \(profile.raised)")
                                                        .font(.footnote)
                                                        .foregroundColor(.green)

                                                    Text(profile.bio)
                                                        .font(.footnote)
                                                        .foregroundColor(.white.opacity(0.85))
                                                        .lineLimit(3)
                                                }
                                                .padding()
                                                .background(.ultraThinMaterial)
                                                .cornerRadius(20)
                                            }
                                            .padding(.bottom, 16)
                                            .padding(.horizontal, 12)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .zIndex(Double(profiles.count - index))
                                    }
                                }
                            }
                        } else {
                            VStack(spacing: 16) {
                                Text("🎉 No more profiles")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.85))
                                    .padding()

                                Button(action: {
                                    currentIndex = 0
                                }) {
                                    Text("🔁 Start Over")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 10)
                                        .background(Color.accentColor)
                                        .cornerRadius(14)
                                        .shadow(radius: 4)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.bottom)
            }
            .fullScreenCover(item: $selectedProfile) { profile in
                ProfileDetailView(profile: profile)
            }
            .navigationDestination(isPresented: $showCompletion) {
                CompletionView()
            }
        }
    }
}

