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
        if fetchAllSpendings().count == 0 {
            createTestingSpendings()
        }
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
    
    func addSpending(amount: Int32, category: String, desc: String, date: Date) -> Spending {
        let spending = NSEntityDescription.insertNewObject(forEntityName: "Spending", into: persistentContainer.viewContext) as! Spending
        spending.amount = amount
        spending.category = category
        spending.desc = desc
        spending.date = date
        
        return spending
    }
        
    func addBudget(budget: Int32) -> Budget {
        let newBudget = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: persistentContainer.viewContext) as! Budget
        newBudget.id = 0
        newBudget.budget = budget
        
        return newBudget
    }
    
    func editBudget(newAmount: Int32) {
        let budget = fetchBudget()
        budget.budget = newAmount
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchBudget() -> Budget {
        var budget: Budget?
        let request: NSFetchRequest<Budget> = Budget.fetchRequest()
        request.fetchLimit = 1
        let context = persistentContainer.viewContext
        do{
            budget = try context.fetch(request).first!
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        return budget!
        
//        do {
//            try budget = persistentContainer.viewContext.fetch(request)
//        } catch {
//            print("Fetch Request failed with error: \(error)")
//        }
//        return budget.first
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
    
    func fetchSpendingByDateAndCategory(month: String, year: String, category: String) -> Int32{
        var intMonth = Int(month)
        intMonth = intMonth! + 1
        let currentMonth = String(intMonth!)
        var totalAmountSpent: Int32 = 0
        var spendings: [Spending] = fetchAllSpendings()
        // Setting up date by combining month and year from parameters
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM"
        let dateString = year + "-" + currentMonth
        let finalDate = dateFormatter.date(from: dateString)
        
        var lastMonth = Int(currentMonth)
        lastMonth = lastMonth! - 1
        let prevMonth = String(lastMonth!)
        let prevDateString = year + "-" + prevMonth
        let prevDate = dateFormatter.date(from: prevDateString)
        
        // Creating predicates
        //        let datePredicate = NSPredicate(format: "date == %@", finalDate! as NSDate)
        let datePredicate = NSPredicate(format:  "(date >= %@) AND (date <= %@)", prevDate! as NSDate, finalDate! as NSDate)
        let categoryPredicate = NSPredicate(format: "category == %@", category)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [datePredicate, categoryPredicate])
        let fetchRequest = NSFetchRequest<Spending>(entityName: "Spending")
        fetchRequest.predicate = andPredicate
        
        do {
            try spendings = persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        
        for spending in spendings {
            totalAmountSpent += spending.amount
//            if catSpendings.category == category {
//                totalAmountSpent += catSpendings.amount
//            }
        }
        
        return totalAmountSpent
    }
    
    func fetchSpendingAmountThisMonth() -> Int32 {
        var monthAmount: Int32 = 0
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM"
        
        let calendar = Calendar.current
        let lastMonthInt = calendar.component(.month, from: date)
        let lastMonth = String(lastMonthInt)
        let currentMonthInt = lastMonthInt + 1
        let currentMonth = String(currentMonthInt)
        let currentYear = String(calendar.component(.year, from: date))
        let prevDateString = currentYear + "-" + lastMonth
        let prevDate = dateFormatter.date(from: prevDateString)
        let dateString = currentYear + "-" + currentMonth
        let finalDate = dateFormatter.date(from: dateString)
        var spendings: [Spending] = fetchAllSpendings()
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", prevDate! as NSDate, finalDate! as NSDate)
        let fetchRequest = NSFetchRequest<Spending>(entityName: "Spending")
        fetchRequest.predicate = predicate
        do {
            try spendings = persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }

        for spending in spendings {
            print(spending.amount)
            monthAmount += spending.amount
            
        }
        
        return monthAmount
    }
    
    func fetchSpendingsOfCategory (category: String) -> Int32{
        var totalAmountSpent: Int32 = 0
        var spendings: [Spending] = fetchAllSpendings()
        let predicate = NSPredicate(format: "category == %@", category)
        let fetchRequest = NSFetchRequest<Spending>(entityName: "Spending")
        fetchRequest.predicate = predicate
        do {
            try spendings = persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        
        for catSpendings in spendings {
            if catSpendings.category == category {
                totalAmountSpent += catSpendings.amount
            }
        }
        
        return totalAmountSpent
    }
    
    func createTestingSpendings() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let _ = addSpending(amount: 43, category: "Food", desc: "Nothing", date: dateFormatter.date(from: "2022-4-10")!)
        let _ = addSpending(amount: 51, category: "Food", desc: "Nothing", date: dateFormatter.date(from: "2022-4-13")!)
        let _ = addSpending(amount: 60, category: "Food", desc: "Nothing", date: dateFormatter.date(from: "2022-4-12")!)
        let _ = addSpending(amount: 50, category: "Food", desc: "Nothing", date: dateFormatter.date(from: "2022-5-10")!)
        let _ = addSpending(amount: 51, category: "Food", desc: "Nothing", date: dateFormatter.date(from: "2022-5-11")!)
    }
    
    
}
