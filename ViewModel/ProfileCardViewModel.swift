//
//  ProfileCardViewModel.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
final class Profile: Identifiable {
    @Attribute(.unique)
    var id: UUID

    var name: String
    var title: String
    var company: String
    var photo: String
    var raised: String
    var role: String
    var bio: String

    init(name: String, title: String, company: String,
         photo: String, raised: String, role: String, bio: String) {
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

@available(iOS 17, *)
@MainActor
class ProfileCardViewModel: ObservableObject {
    @Published var investorProfiles: [Profile] = [
        Profile(name: "Sarah Kim", title: "Partner", company: "Future Fund", photo: "sarah", raised: "$30M", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Tom Lee", title: "Angel", company: "SkyInvest", photo: "tom", raised: "$10M", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Nina Rao", title: "Principal", company: "NextGen Capital", photo: "nina", raised: "$50M", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
    ]

    @Published var coFounderProfiles: [Profile] = [
        Profile(name: "Jess Wong", title: "CTO", company: "Neatflo", photo: "Jess Wong", raised: "$0", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Dave Patel", title: "Engineer", company: "HealthAI", photo: "Dave Patel", raised: "$0", role: "Angel Investor", bio: "Invests in early-stage tech startups."),
        Profile(name: "Zoe Li", title: "Designer", company: "EcoLoop", photo: "Zoe Li", raised: "$0", role: "Angel Investor", bio: "Invests in early-stage tech startups.")
    ]
}

