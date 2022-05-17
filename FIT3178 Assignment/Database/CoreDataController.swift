//
//  CoreDataController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 17/05/2022.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    override init(){
        persistentContainer = NSPersistentContainer(name: "App-DataModel")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        super.init()
    }
    
    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .spending || listener.listenerType == .all {
            listener.onAllSpendingsChange(change: .update, spendings: fetchAllSpendings())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addSpending(amount: String, category: String, desc: String, date: Date) -> Spending {
        let spending = NSEntityDescription.insertNewObject(forEntityName: "Spending", into: persistentContainer.viewContext) as! Spending
        spending.amount = amount
        spending.category = category
        spending.desc = desc
        spending.date = date
        
        return spending
    }
    
    func deleteSpending(spending: Spending) {
        persistentContainer.viewContext.delete(spending)
    }
    
    func fetchAllSpendings() -> [Spending] {
        var spendings = [Spending]()
        
        let request: NSFetchRequest<Spending> = Spending.fetchRequest()
        
        do {
            try spendings = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        return spendings
    }
    
    
    
}
