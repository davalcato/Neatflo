//
//  SplashView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

import SwiftUI

struct SplashView: View {
    @State private var showLogin = false
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var animateLogo = false

    let gradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.2, green: 0.5, blue: 0.3).opacity(0.9),
            Color(red: 0.4, green: 0.7, blue: 0.5).opacity(0.9)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        ZStack {
            gradient.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image("neatflo_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateLogo ? 1.1 : 0.9)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            animateLogo.toggle()
                        }
                    }

                Text("NeatFlo")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 3)

                Text("Network smarter with AI-powered insights")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, -8)

                Spacer()

                Button(action: {
                    withAnimation {
                        showLogin = true
                    }
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.95))
                        .foregroundColor(.green)
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 3)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView(loginData: loginViewModel)
        }
    }
}

#Preview {
    SplashView()
}

