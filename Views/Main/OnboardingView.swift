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
    
    private let onboardingSteps = [
        OnboardingStep(image: "neatflo_logo", title: "Welcome to Neatflo", description: "Your AI-powered networking assistant for smarter, faster connections."),
        OnboardingStep(image: "connection_icon", title: "Smart Connections", description: "Neatflo intelligently organizes your contacts and helps you grow your network."),
        OnboardingStep(image: "insight_icon", title: "Insights That Matter", description: "Visualize your relationship health, activity, and communication patterns."),
        OnboardingStep(image: "goal_icon", title: "Achieve with Purpose", description: "Set connection goals and let Neatflo track and guide your success.")
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.indigo, Color.purple, Color.black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingSteps.count, id: \.self) { index in
                        OnboardingCardView(step: onboardingSteps[index])
                            .tag(index)
                            .padding(.horizontal)
                            .transition(.slide)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .animation(.easeInOut, value: currentPage)
                
                Spacer()
                
                Button(action: {
                    if currentPage < onboardingSteps.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(currentPage < onboardingSteps.count - 1 ? "Next" : "Start Networking")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 32)
                        .shadow(radius: 10)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingStep {
    let image: String
    let title: String
    let description: String
}

struct OnboardingCardView: View {
    let step: OnboardingStep
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(step.image)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .shadow(radius: 10)
                .padding(.bottom, 10)
            
            Text(step.title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            Text(step.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.85))
                .padding(.horizontal, 30)
            
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 5)
    }
}


