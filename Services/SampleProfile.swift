//
//  SampleProfile.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/29/25.
//

import Foundation

struct SampleProfile: Identifiable {
    let id = UUID()
    let name: String
    let title: String
    let company: String
    let photo: String
    let raised: String
    let role: String
    let bio: String
}

@available(iOS 17, *)
let sampleProfiles: [Profile] = [
    Profile(
        name: "Jess Wong",
        title: "CTO",
        company: "Neatflo",
        photo: "sample_photo1",
        raised: "$1.2B",
        role: "Engineer",
        bio: "Building productivity tools with AI."
    ),
    Profile(
        name: "Marcus Lee",
        title: "CEO",
        company: "Visionary Inc.",
        photo: "sample_photo2",
        raised: "$950M",
        role: "Leader",
        bio: "Driving innovation in AR."
    )
]


