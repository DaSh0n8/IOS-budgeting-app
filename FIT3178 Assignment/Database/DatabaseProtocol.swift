//
//  DatabaseProtocol.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 17/05/2022.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case spending
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onAllSpendingsChange(change: DatabaseChange, spendings: [Spending])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func addSpending(amount: String, category: String, desc: String, date: Date) -> Spending
    func deleteSpending(spending: Spending)
}
