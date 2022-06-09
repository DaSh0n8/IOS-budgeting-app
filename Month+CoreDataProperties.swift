//
//  Month+CoreDataProperties.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 06/06/2022.
//
//

import Foundation
import CoreData


extension Month {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Month> {
        return NSFetchRequest<Month>(entityName: "Month")
    }

    @NSManaged public var month: Int32
    @NSManaged public var year: Int32
    @NSManaged public var date: Date?

}

extension Month : Identifiable {

}
