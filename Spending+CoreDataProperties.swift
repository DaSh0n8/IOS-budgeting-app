//
//  Spending+CoreDataProperties.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 17/05/2022.
//
//

import Foundation
import CoreData


extension Spending {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Spending> {
        return NSFetchRequest<Spending>(entityName: "Spending")
    }

    @NSManaged public var amount: String?
    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var date: Date?

}

extension Spending : Identifiable {

}
