//
//  TagButton.swift
//  Neatflo
//
//  Created by Ethan Hunt on 6/7/25.
//

import SwiftUI

struct TagButton: View {
    let tag: String
    @State private var isPressed = false

    var body: some View {
        Text(tag)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isPressed ? Color.accentColor.opacity(0.2) : Color.accentColor.opacity(0.1))
            .foregroundColor(.accentColor)
            .cornerRadius(20)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                    print("Tag tapped: \(tag)")
                }
            }
    }
}


#Preview {
    TagButton(tag: "AI")
        .padding()
        .previewLayout(.sizeThatFits)
}

