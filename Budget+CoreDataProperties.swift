//
//  Budget+CoreDataProperties.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 25/05/2022.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var budget: Int32
    @NSManaged public var id: Int16

}

extension Budget : Identifiable {

}
