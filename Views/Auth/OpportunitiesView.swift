//
//  OpportunitiesView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import Foundation
import SwiftUICore
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var investorProfiles: [Profile] = [
        Profile(name: "Sarah Kim", title: "Partner", company: "Future Fund", photo: "sarah", raised: "$30M", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Tom Lee", title: "Angel", company: "SkyInvest", photo: "tom", raised: "$10M", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Nina Rao", title: "Principal", company: "NextGen Capital", photo: "nina", raised: "$50M", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
    ]

    @Published var coFounderProfiles: [Profile] = [
        Profile(name: "Jess Wong", title: "CTO", company: "Neatflo", photo: "Jess Wong", raised: "$0", role: "Engineer", bio: "Building productivity tools with AI."),
        Profile(name: "Dave Patel", title: "Engineer", company: "HealthAI", photo: "Dave Patel", raised: "$0", role: "Engineer", bio: "Focuses on AI-powered healthcare solutions."),
        Profile(name: "Zoe Li", title: "Designer", company: "EcoLoop", photo: "Zoe Li", raised: "$0", role: "Designer", bio: "Passionate about sustainable design.")
    ]
}

@available(iOS 17.0, *)
struct OpportunitiesView: View {
    @StateObject var viewModel = OpportunitiesViewModel()
    @ObservedObject var profileVM: ProfileViewModel
    @State private var selectedOpportunity: Opportunity?
    @State private var showProfiles = false

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading && viewModel.opportunities.isEmpty {
                    ProgressView().scaleEffect(1.5)
                } else {
                    opportunityList
                }
            }
            .navigationTitle("Opportunities")
            .onAppear {
                viewModel.fetchOpportunities()
            }
            .navigationDestination(isPresented: $showProfiles) {
                if let opportunity = selectedOpportunity {
                    if opportunity.title == "Investor Introduction" {
                        SwipeableProfileView(profiles: profileVM.investorProfiles)
                    } else if opportunity.title == "Co-Founder Match" {
                        SwipeableProfileView(profiles: profileVM.coFounderProfiles)
                    } else {
                        Text("No profiles available")
                    }
                }
            }
        }
    }

    private var opportunityList: some View {
        List {
            ForEach(viewModel.opportunities, id: \.id) { opportunity in
                OpportunityCard(opportunity: opportunity) {
                    Button(action: {
                        selectedOpportunity = opportunity
                        showProfiles = true
                    }) {
                        Text("View Details")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .animation(.easeInOut, value: viewModel.opportunities)
    }
}

@available(iOS 17.0, *)
#Preview {
    OpportunitiesView(profileVM: ProfileViewModel())
}

    // MARK: - Preview

    @available(iOS 17.0, *)
    #Preview {
        OpportunitiesView(profileVM: ProfileViewModel())
    }

