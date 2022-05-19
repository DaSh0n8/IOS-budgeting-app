//
//  Spending+CoreDataProperties.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 18/05/2022.
//
//

import Foundation
import CoreData


extension Spending {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Spending> {
        return NSFetchRequest<Spending>(entityName: "Spending")
    }

    @NSManaged public var amount: Int32
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var desc: String?

}

extension Spending : Identifiable {

}
