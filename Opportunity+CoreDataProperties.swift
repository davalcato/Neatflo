//
//  Opportunity+CoreDataProperties.swift
//  
//
//  Created by Ethan Hunt on 5/10/25.
//
//

import Foundation
import CoreData


extension Opportunity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Opportunity> {
        return NSFetchRequest<Opportunity>(entityName: "Opportunity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var company: String?
    @NSManaged public var summary: String?
    @NSManaged public var matchStrength: Double
    @NSManaged public var timestamp: Date?

}
