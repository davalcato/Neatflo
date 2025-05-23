//
//  ProfileCardViewModel.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import Foundation

struct Profile: Identifiable, Equatable {
    let id: UUID
    let name: String
    let title: String
    let company: String
    let photo: String
    let raised: String
    let role: String
    let bio: String

    init(name: String, title: String, company: String, photo: String, raised: String, role: String, bio: String) {
        self.id = UUID()
        self.name = name
        self.title = title
        self.company = company
        self.photo = photo
        self.raised = raised
        self.role = role
        self.bio = bio
    }
}

@MainActor
class ProfileCardViewModel: ObservableObject {
    @Published var investorProfiles: [Profile] = [
        Profile(name: "Sarah Kim", title: "Partner", company: "Future Fund", photo: "sarah", raised: "$30M", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Tom Lee", title: "Angel", company: "SkyInvest", photo: "tom", raised: "$10M", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Nina Rao", title: "Principal", company: "NextGen Capital", photo: "nina", raised: "$50M", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
    ]

    @Published var coFounderProfiles: [Profile] = [
        Profile(name: "Jess Wong", title: "CTO", company: "Neatflo", photo: "jess", raised: "$0", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Dave Patel", title: "Engineer", company: "HealthAI", photo: "dave", raised: "$0", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Zoe Li", title: "Designer", company: "EcoLoop", photo: "zoe", raised: "$0", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
    ]
}

