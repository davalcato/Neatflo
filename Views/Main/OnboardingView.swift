//
//  OnboardingView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/19/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    
    private let onboardingData: [(image: String, title: String, description: String)] = [
        ("neatflo_logo", "Welcome to Neatflo", "Your smart networking companion for managing and growing professional relationships."),
        ("connection_icon", "Connect Intelligently", "Find new contacts and sync them with insights that help build lasting value."),
        ("insight_icon", "Gain Insights", "Understand your network with intelligent summaries and actionable data."),
        ("goal_icon", "Achieve Goals", "Set networking goals and let Neatflo guide your journey step-by-step.")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        Spacer()
                        Image(onboardingData[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .padding(.top, 40)

                        Text(onboardingData[index].title)
                            .font(.title)
                            .fontWeight(.semibold)

                        Text(onboardingData[index].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                        
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .animation(.easeInOut, value: currentPage)

            Button(action: {
                if currentPage < onboardingData.count - 1 {
                    currentPage += 1
                } else {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    hasSeenOnboarding = true
                }
            }) {
                Text(currentPage < onboardingData.count - 1 ? "Next" : "Get Started")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 20)
            }
        }
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}


