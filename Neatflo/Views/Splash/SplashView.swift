//
//  SplashView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemBackground) // Adapts to light/dark mode
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Logo from Assets
                Image("neatflo_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                // Optional tagline (remove if not needed)
                Text("Network smarter")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .onAppear {
            viewModel.checkAuthStatus()
        }
        .fullScreenCover(isPresented: $viewModel.isActive) {
            if AuthService.shared.isLoggedIn {
                FeedView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    SplashView()
}
