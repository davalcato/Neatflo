//
//  PersistenceController.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/10/25.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NeatfloDataModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Create and configure a new Opportunity entity
        let newOpportunity = NSEntityDescription.insertNewObject(
            forEntityName: "Opportunity",
            into: viewContext
        ) as! OpportunityMO  // Your NSManagedObject subclass
        
        newOpportunity.id = UUID()
        newOpportunity.title = "Preview Opportunity"
        newOpportunity.company = "Preview Company"
        newOpportunity.summary = "This is preview data"
        newOpportunity.matchStrength = 0.85
        newOpportunity.timestamp = Date()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()
}
