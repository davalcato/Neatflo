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
                for: Opportunity.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            fatalError("❌ Failed to initialize Neatflo's data storage: \(error)")
        }
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        print("✅ AppDelegate didFinishLaunchingWithOptions called")
        initializeFirstRunData()
        return true
    }

    // MARK: - First Run Setup
    @MainActor private func initializeFirstRunData() {
        let defaults = UserDefaults.standard
        
        if !defaults.bool(forKey: "neatfloHasLaunchedBefore") {
            defaults.set(true, forKey: "neatfloHasLaunchedBefore")
            
            if #available(iOS 17, *) {
                seedInitialOpportunities()
            }
        }
    }

    @MainActor @available(iOS 17, *)
    private func seedInitialOpportunities() {
        let context = AppDelegate.sharedModelContainer.mainContext
        
        let fetchRequest = FetchDescriptor<Opportunity>()
        guard (try? context.fetch(fetchRequest).isEmpty) == true else { return }
        
        let mockOpportunities = [
            Opportunity(
                title: "Investor Match",
                company: "Capital Partners",
                summary: "Connect with seed-stage investors",
                matchStrength: 0.88,
                timestamp: Date()
            ),
            Opportunity(
                title: "Technical Co-founder",
                company: "Founder Network",
                summary: "Meet potential technical partners",
                matchStrength: 0.91,
                timestamp: Date().addingTimeInterval(-86400)
            )
        ]
        
        mockOpportunities.forEach { context.insert($0) }
        
        do {
            try context.save()
        } catch {
            print("⚠️ Neatflo failed to seed initial data: \(error)")
        }
    }

    // MARK: - Debug Tool
    @MainActor @available(iOS 17, *)
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





