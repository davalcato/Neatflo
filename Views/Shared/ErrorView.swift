//
//  ErrorView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/30/25.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("🚨 Oops!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(error)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: onDismiss) {
                Text("Dismiss")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}


#Preview {
    ErrorView(error: "Something went wrong. Please try again later.") {
        print("Dismiss tapped")
    }
}

