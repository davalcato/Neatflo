//
//  SplashView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

import SwiftUI

struct SplashView: View {
    @State private var showLogin = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                Image("neatflo_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .scaleEffect(showLogin ? 1.1 : 1)
                    .animation(.easeInOut(duration: 0.6), value: showLogin)

                Text("Network smarter")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .opacity(0.7)

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
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
    }
}


#Preview {
    SplashView()
}
