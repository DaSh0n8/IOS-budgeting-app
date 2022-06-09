//
//  CoreDataController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 17/05/2022.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    var allSpendingsFetchedResultsController: NSFetchedResultsController<Spending>?
    
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allSpendingsFetchedResultsController {
            listeners.invoke() { listener in
                if listener.listenerType == .spending || listener.listenerType == .all {
                    listener.onAllSpendingsChange(change: .update, spendings: fetchAllSpendings())
                }
            }
        }
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
    
    func addMonth(month: Int32, year: Int32, date: Date) -> Month{
        let newMonth = NSEntityDescription.insertNewObject(forEntityName: "Month", into: persistentContainer.viewContext) as! Month
        newMonth.month = month
        newMonth.year = year
        newMonth.date = date
        
        return newMonth
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
            budget = try context.fetch(request).first
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        
        if budget == nil {
            budget = addBudget(budget: 10)
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
        if allSpendingsFetchedResultsController == nil {
            let request: NSFetchRequest<Spending> = Spending.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            allSpendingsFetchedResultsController = NSFetchedResultsController<Spending>(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            allSpendingsFetchedResultsController?.delegate = self
        }
        do {
            try allSpendingsFetchedResultsController?.performFetch()
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        if let spendings = allSpendingsFetchedResultsController?.fetchedObjects {
            return spendings
        }
        return [Spending]()
//        var spendings = [Spending]()
//
//        let request: NSFetchRequest<Spending> = Spending.fetchRequest()
//
//        do {
//            try spendings = persistentContainer.viewContext.fetch(request)
//        } catch {
//            print("Fetch Request failed with error: \(error)")
//        }
//        return spendings
    }
    
    func fetchSpendingByDateAndCategory(month: String, year: String, category: String) -> Int32{
        let finalDate: Date?
        let prevDate: Date?
        var spendings: [Spending] = fetchAllSpendings()
        var totalAmountSpent: Int32 = 0
        if month == "1" {
            var intMonth = Int(month)
            intMonth = intMonth! + 1
            let currentMonth = String(intMonth!)
            
            
            // Setting up date by combining month and year from parameters
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM"
            let dateString = year + "-" + currentMonth
            finalDate = dateFormatter.date(from: dateString)
            
            let ly = Int(year)!
            let lastYear = ly - 1
            let lastMonth = Int(12)
            let prevMonth = String(lastMonth)
            let prevDateString = String(lastYear) + "-" + prevMonth
            prevDate = dateFormatter.date(from: prevDateString)
        } else if month == "12" {
            
            let intMonth = 1
            let currentMonth = String(intMonth)
            
            // Setting up date by combining month and year from parameters
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM"
            let ny = Int(year)!
            let nextYear = ny + 1
            let dateString = String(nextYear) + "-" + currentMonth
            finalDate = dateFormatter.date(from: dateString)
            
            let lastMonth = 11
            let prevMonth = String(lastMonth)
            let prevDateString = year + "-" + prevMonth
            prevDate = dateFormatter.date(from: prevDateString)
        }
        else {
            var intMonth = Int(month)
            intMonth = intMonth! + 1
            let currentMonth = String(intMonth!)
            
            // Setting up date by combining month and year from parameters
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM"
            let dateString = year + "-" + currentMonth
            finalDate = dateFormatter.date(from: dateString)
            
            var lastMonth = Int(currentMonth)
            lastMonth = lastMonth! - 1
            let prevMonth = String(lastMonth!)
            let prevDateString = year + "-" + prevMonth
            prevDate = dateFormatter.date(from: prevDateString)
        }
        
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
    
    func fetchTotalEachMonth(month: String, year: String) -> Int32{
        let finalDate: Date?
        let prevDate: Date?
        var spendings: [Spending] = fetchAllSpendings()
        var totalAmountSpent: Int32 = 0
        if month == "1" {
            var intMonth = Int(month)
            intMonth = intMonth! + 1
            let currentMonth = String(intMonth!)
            
            
            // Setting up date by combining month and year from parameters
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM"
            let dateString = year + "-" + currentMonth
            finalDate = dateFormatter.date(from: dateString)
            
            let ly = Int(year)!
            let lastYear = ly - 1
            let lastMonth = Int(12)
            let prevMonth = String(lastMonth)
            let prevDateString = String(lastYear) + "-" + prevMonth
            prevDate = dateFormatter.date(from: prevDateString)
        } else if month == "12" {
            
            let intMonth = 1
            let currentMonth = String(intMonth)
            
            // Setting up date by combining month and year from parameters
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM"
            let ny = Int(year)!
            let nextYear = ny + 1
            let dateString = String(nextYear) + "-" + currentMonth
            finalDate = dateFormatter.date(from: dateString)
            
            let lastMonth = 11
            let prevMonth = String(lastMonth)
            let prevDateString = year + "-" + prevMonth
            prevDate = dateFormatter.date(from: prevDateString)
        }
        else {
            var intMonth = Int(month)
            intMonth = intMonth! + 1
            let currentMonth = String(intMonth!)
            
            // Setting up date by combining month and year from parameters
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM"
            let dateString = year + "-" + currentMonth
            finalDate = dateFormatter.date(from: dateString)
            
            var lastMonth = Int(currentMonth)
            lastMonth = lastMonth! - 1
            let prevMonth = String(lastMonth!)
            let prevDateString = year + "-" + prevMonth
            prevDate = dateFormatter.date(from: prevDateString)
        }
        
        // Creating predicates
        //        let datePredicate = NSPredicate(format: "date == %@", finalDate! as NSDate)
        let datePredicate = NSPredicate(format:  "(date >= %@) AND (date <= %@)", prevDate! as NSDate, finalDate! as NSDate)
        let fetchRequest = NSFetchRequest<Spending>(entityName: "Spending")
        fetchRequest.predicate = datePredicate
        
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
           // print(spending.amount)
            monthAmount += spending.amount
            
        }
        
        return monthAmount
    }
    
    func fetchSpendingAmountByMonth(month: Int) -> Int32 {
        var monthAmount: Int32 = 0
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM"
        
        let calendar = Calendar.current
        let currentYear = String(calendar.component(.year, from: date))
        
        let prevMonth = month
        let currentMonth = month + 1
        let prevMonthString = String(month)
        let currentMonthString = String(currentMonth)
        let prevDateString = currentYear + "-" + prevMonthString
        let prevDate = dateFormatter.date(from: prevDateString)
        let currentDateString = currentYear + "-" + currentMonthString
        let finalDate = dateFormatter.date(from: currentDateString)
        
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
    
    func addMonthsFromSpendings() {
        let spendings: [Spending] = fetchAllSpendings()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM"
        let calendar = Calendar.current
        for spending in spendings {
            let spendingMonth = calendar.component(.month, from: spending.date!)
            let spendingYear = calendar.component(.year, from: spending.date!)
            let spendingDateString = String(spendingYear) + "-" + String(spendingMonth)
            let spendingDate = dateFormatter.date(from: spendingDateString)!
            
            if checkIfMonthExists(month: spendingMonth, year: spendingYear) == false {
                let _ = addMonth(month: Int32(spendingMonth), year: Int32(spendingYear), date: spendingDate)
            }
        }
    }
    
    func checkIfMonthExists(month: Int, year: Int) -> Bool{
        var months: [Month] = fetchAllMonths()
        let request: NSFetchRequest<Month> = Month.fetchRequest()
        request.fetchLimit = 1
        let monthPredicate = NSPredicate(format: "month == %@", month)
        let yearPredicate = NSPredicate(format: "year == %@", year)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [monthPredicate, yearPredicate])
        let fetchRequest = NSFetchRequest<Month>(entityName: "Month")
        fetchRequest.predicate = andPredicate

        do{
            try months = persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        
        if months.count == 0{
            return false
        } else {
            return true
        }
        
    }
    
    func getTotalSpendingsOnEachMonth() -> [Int] {
        var totalSpendingArray = [Int]()
        let months: [Month] = fetchAllMonths()
        for month in months {
            let amount = fetchSpendingAmountByMonth(month: Int(month.month))
            //we dont know the month
            totalSpendingArray.append(Int(amount))
        }
        return totalSpendingArray
    }
    
    func fetchAllMonths() -> [Month] {
        var months = [Month]()
        
        let request: NSFetchRequest<Month> = Month.fetchRequest()
        
        do {
            try months = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        return months
    }
    
    func createTestingSpendings() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let _ = addSpending(amount: 43, category: "Food", desc: "Nothing", date: dateFormatter.date(from: "2022-4-10")!)
        let _ = addSpending(amount: 51, category: "Food", desc: "Nothing", date: dateFormatter.date(from: "2022-5-13")!)
        let _ = addSpending(amount: 60, category: "Food", desc: "Nothing", date: dateFormatter.date(from: "2022-5-12")!)
        let _ = addSpending(amount: 50, category: "Food", desc: "Nothing", date: dateFormatter.date(from: "2022-6-10")!)
        let _ = addSpending(amount: 51, category: "Food", desc: "Nothing", date: dateFormatter.date(from: "2022-6-11")!)
    }
    
    
}
