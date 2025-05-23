//
//  SwipeableCardView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import SwiftUI

struct SwipeableCardView<Content: View>: View {
    let content: () -> Content
    var onSwipeLeft: () -> Void = {}
    var onSwipeRight: () -> Void = {}

    @State private var offset: CGSize = .zero

    var body: some View {
        content()
            .cardView()
            .offset(x: offset.width, y: 0)
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        if offset.width > 100 {
                            onSwipeRight()
                        } else if offset.width < -100 {
                            onSwipeLeft()
                        }
                        offset = .zero
                    }
            )
            .animation(.spring(), value: offset)
    }
}

#Preview {
    SwipeableCardView(
        content: {
            VStack(alignment: .leading) {
                Text("Sample Opportunity")
                    .font(.headline)
                Text("This is a preview card.")
                    .font(.subheadline)
            }
        },
        onSwipeLeft: {
            print("Swiped Left")
        },
        onSwipeRight: {
            print("Swiped Right")
        }
    )
    .padding()
    .previewLayout(.sizeThatFits)
}


