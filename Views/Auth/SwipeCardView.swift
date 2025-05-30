//
//  SwipeCardView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/28/25.
//

import SwiftUI

@available(iOS 17, *)
struct SwipeCardView: View {
    let profile: Profile
    let onRemove: (_ profile: Profile, _ direction: SwipeDirection) -> Void

    @State private var offset = CGSize.zero
    @GestureState private var isDragging = false

    enum SwipeDirection {
        case left, right
    }

    var body: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width * 0.92
            let cardHeight = geometry.size.height * 0.75

            ZStack(alignment: .bottomLeading) {
                Image(profile.photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardWidth, height: cardHeight)
                    .clipped()
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .overlay(
                        // Gradient overlay for better text readability
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .cornerRadius(20)
                    )
                    .overlay(
                        // White text at the bottom-left corner
                        VStack(alignment: .leading, spacing: 4) {
                            Text(profile.title)
                                .font(.headline)
                                .bold()
                            Text(profile.company)
                                .font(.subheadline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .padding(.bottom, 12),
                        alignment: .bottomLeading
                    )
                    .offset(x: offset.width, y: offset.height)
                    .rotationEffect(.degrees(Double(offset.width / 20))) // for page-turn feel
                    .scaleEffect(isDragging ? 1.05 : 1.0) // slightly enlarge during drag
                    .gesture(
                        DragGesture()
                            .updating($isDragging) { _, state, _ in
                                state = true
                            }
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { gesture in
                                if abs(gesture.translation.width) > 120 {
                                    let direction: SwipeDirection = gesture.translation.width > 0 ? .right : .left
                                    withAnimation(.spring()) {
                                        offset = CGSize(width: gesture.translation.width * 5, height: 0)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        onRemove(profile, direction)
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        offset = .zero
                                    }
                                }
                            }
                    )
                    .animation(.interactiveSpring(), value: offset)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    if #available(iOS 17, *) {
        let profile = Profile(
            name: "Jess Wong",
            title: "CTO",
            company: "Neatflo",
            photo: "Jess Wong", // Must match asset name exactly
            raised: "$0",
            role: "Angel Investor",
            bio: "Invests in early-stage tech startups."
        )

        SwipeCardView(profile: profile) { profile, direction in
            print("User swiped \(direction == .right ? "right" : "left") on \(profile.name)")
        }
    } else {
        Text("iOS 17+ required")
    }
}



