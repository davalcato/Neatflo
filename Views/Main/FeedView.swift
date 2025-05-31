//
//  FeedView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

// FeedView.swift

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct FeedView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: FeedViewModel
    @StateObject private var profileVM = ProfileCardViewModel()

    @State private var showingProfile = false
    @State private var navigateToSwipeView = false
    @State private var selectedOpportunity: Opportunity?

    init() {
        let context = ModelContext(Persistence.shared.container)
        _viewModel = StateObject(wrappedValue: FeedViewModel(modelContext: context))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background
                LinearGradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                if viewModel.isLoading && viewModel.opportunities.isEmpty {
                    ProgressView("Loading...")
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                } else {
                    opportunityList
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if let error = viewModel.errorMessage {
                    ErrorView(error: error, onDismiss: { viewModel.errorMessage = nil })
                }
            }
            .navigationTitle("🎯 Neatflo Matches")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingProfile.toggle() }) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .shadow(radius: 3)
                            .scaleEffect(showingProfile ? 1.1 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showingProfile)
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
            .refreshable {
                await viewModel.refresh()
            }
            .navigationDestination(isPresented: $navigateToSwipeView) {
                if let opportunity = selectedOpportunity, opportunity.title == "Co-Founder Match" {
                    SwipeableProfileView(profiles: profileVM.coFounderProfiles)
                }
            }
        }
    }

    // MARK: - Opportunity List View
    private var opportunityList: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.opportunities, id: \.id) { opportunity in
                    OpportunityCard(opportunity: opportunity) {
                        Group {
                            if opportunity.title == "Investor Introduction" {
                                ProfileCardView(profiles: profileVM.investorProfiles)
                            } else if opportunity.title == "Co-Founder Match" {
                                SwipeableProfileView(profiles: profileVM.coFounderProfiles)
                            } else {
                                Text("Details not available")
                            }
                        }
                    }
                    .background(BlurView(style: .systemMaterial))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    .transition(.scale)
                }
            }
            .padding(.top)
        }
        .animation(.easeInOut, value: viewModel.opportunities)
    }
}

// MARK: - Optional Blur Background Helper
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}


// MARK: - Error View
struct ErrorView: View {
    let error: String
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.yellow)
            
            Text("Error")
                .font(.title2.bold())
            
            Text(error)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.horizontal)
            
            Button(action: onDismiss) {
                Text("OK")
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
        .frame(width: 280)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .transition(.scale.combined(with: .opacity))
        .zIndex(1)
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                Form {
                    Section {
                        HStack {
                            Spacer()
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)
                                .padding(.vertical)
                            Spacer()
                        }
                    }
                    
                    Section("Account") {
                        Text("Settings")
                        Text("Notifications")
                        Text("Privacy")
                    }
                    
                    Section {
                        Button("Sign Out", role: .destructive) {
                            // Handle sign out
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Your Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK: - Preview
#Preview {
    let result: Result<AnyView, Error> = Result {
        if #available(iOS 17, *) {
            let container = try ModelContainer(
                for: Opportunity.self,
                configurations: ModelConfiguration(
                    isStoredInMemoryOnly: true
                )
            )

            let testProfile = Profile(
                name: "Jess Wong",
                title: "CTO",
                company: "Neatflo Ventures",
                photo: "jess",
                raised: "$0",
                role: "Engineer",
                bio: "Building productivity tools with AI."
            )

            let testOpportunity = Opportunity(
                title: "Seed Funding",
                company: "Neatflo Ventures",
                summary: "Preview data",
                matchStrength: 0.85,
                timestamp: Date(),
                profile: testProfile
            )

            container.mainContext.insert(testOpportunity)

            return AnyView(FeedView().modelContainer(container))
        } else {
            return AnyView(Text("iOS 17+ required for this preview"))
        }
    }

    return Group {
        switch result {
        case .success(let view):
            view
        case .failure(let error):
            Text("Preview Error: \(error.localizedDescription)")
                .foregroundColor(.red)
        }
    }
}


