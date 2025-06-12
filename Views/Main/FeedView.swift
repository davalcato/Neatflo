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
    @State private var selectedTag: String?

    init() {
        let context = ModelContext(Persistence.shared.container)
        _viewModel = StateObject(wrappedValue: FeedViewModel(modelContext: context))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 🌈 Animated Gradient Background
                LinearGradient(colors: [.purple.opacity(0.7), .blue.opacity(0.6), .pink.opacity(0.5)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .animation(.linear(duration: 8).repeatForever(autoreverses: true), value: UUID())
                
                if viewModel.isLoading && viewModel.opportunities.isEmpty {
                    ProgressView()
                        .scaleEffect(2)
                        .tint(.white)
                } else {
                    opportunityList
                }
                
                if let error = viewModel.errorMessage {
                    ErrorView(error: error, onDismiss: { viewModel.errorMessage = nil })
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .navigationTitle("🎯 Neatflo Matches")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingProfile.toggle() }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.white)
                            .shadow(color: .blue, radius: 5)
                            .scaleEffect(showingProfile ? 1.1 : 1)
                            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: showingProfile)
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
            .navigationDestination(isPresented: Binding(
                get: { selectedTag != nil },
                set: { if !$0 { selectedTag = nil } }
            )) {
                if let tag = selectedTag {
                    TagDetailView(tag: tag)
                }
            }
        }
    }

    // 🎴 Animated and styled Opportunity List
    private var opportunityList: some View {
        ScrollView {
            LazyVStack(spacing: 25) {
                ForEach(viewModel.opportunities, id: \.id) { opportunity in
                    VStack(spacing: 12) {
                        OpportunityCard(opportunity: opportunity) {
                            // Action for View Details
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

                        // 👇 Functional tags
                        OpportunityTagsView(tags: opportunity.tags) { tag in
                            selectedTag = tag
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .blur(radius: 0.3)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 5)
                    )
                    .padding(.horizontal)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical)
        }
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
    
    // MARK: - Preview
    #Preview {
        let result: Result<AnyView, Error> = Result {
            if #available(iOS 17, *) {
                let container = try ModelContainer(
                    for: Opportunity.self, Profile.self,
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
                    tags: ["AI", "Productivity", "Funding"], // ✅ Tags filled in
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

    
    

