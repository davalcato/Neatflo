//
//  OpportunityMO.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/11/25.
//

import Foundation
import CoreData

@objc(OpportunityMO)
public class OpportunityMO: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var company: String
    @NSManaged public var summary: String
    @NSManaged public var matchStrength: Double
    @NSManaged public var timestamp: Date
}

extension OpportunityMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<OpportunityMO> {
        return NSFetchRequest<OpportunityMO>(entityName: "Opportunity")
    }
}
