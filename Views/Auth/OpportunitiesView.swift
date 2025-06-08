//
//  OpportunitiesView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import SwiftUI
import Foundation

@available(iOS 17, *)
class ProfileViewModel: ObservableObject {
    @Published var investorProfiles: [Profile] = [
        Profile(name: "Sarah Kim", title: "Partner", company: "Future Fund", photo: "sarah", raised: "$30M", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Tom Lee", title: "Angel", company: "SkyInvest", photo: "tom", raised: "$10M", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Nina Rao", title: "Principal", company: "NextGen Capital", photo: "nina", raised: "$50M", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
    ]
    
    @Published var coFounderProfiles: [Profile] = [
        Profile(name: "Jess Wong", title: "CTO", company: "Neatflo", photo: "jess", raised: "$0", role: "Engineer", bio: "Building productivity tools with AI."),
        Profile(name: "Dave Patel", title: "Engineer", company: "HealthAI", photo: "dave", raised: "$0", role: "Engineer", bio: "Focuses on AI-powered healthcare solutions."),
        Profile(name: "Zoe Li", title: "Designer", company: "EcoLoop", photo: "zoe", raised: "$0", role: "Designer", bio: "Passionate about sustainable design.")
    ]
}

@available(iOS 17, *)
struct OpportunitiesView: View {
    @StateObject var viewModel = OpportunitiesViewModel()
    @StateObject var profileVM: ProfileViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.purple.opacity(0.6), .blue.opacity(0.6)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.opportunities.isEmpty {
                    ProgressView("Loading Opportunities...")
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                } else {
                    opportunityList
                }
            }
            .navigationTitle("Opportunities")
            .onAppear {
                viewModel.fetchOpportunities()
            }
        }
    }

    private var opportunityList: some View {
        List {
            ForEach(viewModel.opportunities, id: \.id) { opportunity in
                OpportunityCard(
                    opportunity: opportunity,
                    destination: { () -> AnyView in   // <-- return AnyView instead of some View
                        let title = opportunity.title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

                        if title.contains("investor") {
                            return AnyView(SwipeableProfileView(profiles: profileVM.investorProfiles))
                        } else if title.contains("co-founder") || title.contains("cofounder") {
                            return AnyView(SwipeableProfileView(profiles: profileVM.coFounderProfiles))
                        } else {
                            return AnyView(
                                Text("Details not available")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            )
                        }
                    }
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .padding(.top)
        .animation(.easeInOut, value: viewModel.opportunities)
    }

}

// Helper extension to erase type when returning different views
extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

@available(iOS 17.0, *)
#Preview {
    OpportunitiesView(profileVM: ProfileViewModel())
}





