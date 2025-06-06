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
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGSize = .zero
    @State private var dismissed: Bool = false
    @State private var selectedProfile: Profile?
    @State private var showCompletion = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
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
                                            Image(profile.photo)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.75)
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
                                                                    currentIndex += 1
                                                                    dragOffset = .zero

                                                                    if currentIndex == profiles.count - 1 {
                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                                            showCompletion = true
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
                        } else {
                            VStack(spacing: 16) {
                                Text("🎉 No more profiles")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding()

                                Button(action: {
                                    currentIndex = 0
                                }) {
                                    Text("🔁 Start Over")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(12)
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

