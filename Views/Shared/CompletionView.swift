//
//  CompletionView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 6/4/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct CompletionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(colors: [.purple, .blue, .pink],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .shadow(radius: 10)

                Text("You're All Caught Up!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("You've viewed all the matches for now. Check back later or start over to see them again.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.white.opacity(0.9))

                // Start Over Button
                Button(action: {
                    showAlert = true
                }) {
                    Text("🔁 Start Over")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.blue.opacity(0.85))
                                .shadow(radius: 8)
                        )
                        .padding(.horizontal)
                }
                .alert("Start Over?", isPresented: $showAlert) {
                    Button("Yes, Restart", role: .destructive) {
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This will reset your current session.")
                }
            }
            .padding()
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        CompletionView()
    } else {
        // Fallback on earlier versions
    }
}

