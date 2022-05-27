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
    
    func addSpending(amount: Int32, category: String, desc: String, date: Date) -> Spending
    func fetchSpendingByDateAndCategory(month: String, year: String, category: String) -> Int32
    func fetchSpendingsOfCategory (category: String) -> Int32
    func fetchSpendingAmountThisMonth() -> Int32
    func addBudget(budget: Int32) -> Budget
    func editBudget(newAmount: Int32)
    func deleteSpending(spending: Spending)
    func fetchBudget() -> Budget
}
