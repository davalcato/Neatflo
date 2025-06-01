//
//  AppDelegate.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/27/25.
//

import UIKit
import SwiftUI
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // MARK: - SwiftData Setup
    @available(iOS 17, *)
    static var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(
                for: Opportunity.self, Profile.self, // 👈 Include all your models
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            fatalError("❌ Failed to initialize Neatflo's data storage: \(error)")
        }
    }()
    
    // MARK: - App Launch
    @MainActor
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        print("✅ AppDelegate didFinishLaunchingWithOptions called")
        initializeFirstRunData()
        return true
    }

    // MARK: - First Run Setup
    @MainActor
    private func initializeFirstRunData() {
        let defaults = UserDefaults.standard
        
        if !defaults.bool(forKey: "neatfloHasLaunchedBefore") {
            defaults.set(true, forKey: "neatfloHasLaunchedBefore")
            
            if #available(iOS 17, *) {
                seedInitialOpportunities()
            }
        }
    }

    // MARK: - Mock Data Seeder
    @MainActor
    @available(iOS 17, *)
    private func seedInitialOpportunities() {
        let context = AppDelegate.sharedModelContainer.mainContext

        let fetchRequest = FetchDescriptor<Opportunity>()
        guard (try? context.fetch(fetchRequest).isEmpty) == true else { return }

        let sampleProfile = Profile(
            name: "Jess Wong",
            title: "Startup Mentor",
            company: "Elevate Labs",
            photo: "Jess Wong", // Make sure this image is in Assets.xcassets
            raised: "$1.2M",
            role: "Mentor",
            bio: "Helping startups scale and secure early investments."
        )

        let mockOpportunities = [
            Opportunity(
                title: "Investor Match",
                company: "Capital Partners",
                summary: "Connect with seed-stage investors",
                matchStrength: 0.88,
                timestamp: Date(),
                tags: ["Investment", "Networking", "Startups"],
                profile: sampleProfile
            ),
            Opportunity(
                title: "Technical Co-founder",
                company: "Founder Network",
                summary: "Meet potential technical partners",
                matchStrength: 0.91,
                timestamp: Date().addingTimeInterval(-86400),
                tags: ["Co-founder", "Tech", "Partnership"],
                profile: sampleProfile
            )
        ]

        mockOpportunities.forEach { context.insert($0) }

        do {
            try context.save()
        } catch {
            print("⚠️ Neatflo failed to seed initial data: \(error)")
        }
    }


    // MARK: - Debug Tool: Reset All Data
    @MainActor
    @available(iOS 17, *)
    func resetAllData() {
        let context = AppDelegate.sharedModelContainer.mainContext
        
        do {
            try context.delete(model: Opportunity.self)
            UserDefaults.standard.removeObject(forKey: "neatfloHasLaunchedBefore")
            seedInitialOpportunities()
        } catch {
            print("⚠️ Neatflo reset failed: \(error)")
        }
    }
}








