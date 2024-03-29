//
//  BudgetViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 29/04/2022.
//

import UIKit
import CoreData
import UserNotifications

class BudgetViewController: UIViewController, SetBudgetDelegate, UITableViewDelegate, UITableViewDataSource{
    
    func setToBudget(_ budget: Int32) {
        budgetText.text = "$ \(String(budget))"
        pageBudget = budget
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound])
            { (granted, error) in
        }
        
        databaseController = CoreDataController()
        let date = Date()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM"
        
        let calendar = Calendar.current
        let currentMonth = String(calendar.component(.month, from: date))
        let currentYear = String(calendar.component(.year, from: date))
        
        let dateString = currentYear + "-" + currentMonth
        let monthYear = dateFormatter.date(from: dateString)
        monthText.text = dateFormatter.string(from: monthYear!)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        databaseController = appDelegate?.databaseController
        
        
        let tempBudget = databaseController?.fetchBudget()
        budgetText.text = "$ \(String(tempBudget!.budget))"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                               forCellReuseIdentifier: "CategoryCell")
        
        let spendingThisMonth = databaseController?.fetchSpendingAmountThisMonth()
        spendingText.text = "$ \(String(spendingThisMonth ?? 0))"
        if tempBudget!.budget > spendingThisMonth! {
            spendingText.textColor = UIColor(named: "GreenColour")
        } else {
            spendingText.textColor = UIColor(named: "RedColour")
        }
        // Do any additional setup after loading the view.
        
        // Creating condition for notification trigger
        let notiAmount = (tempBudget!.budget * 80) / 100
        if spendingThisMonth! > notiAmount && tempBudget!.budget > spendingThisMonth! {
            // Creating notification content
            
            let content = UNMutableNotificationContent()
            content.title = "Nearing Budget"
            content.body = "You are about to exceed 80% of your budget this month"
            
            // Creating notification trigger
            
            let notiDate = Date().addingTimeInterval(15)
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notiDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // Creating request
            
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            // Register request
            
            center.add(request) { (error) in
                
            }
        }
    }
    
    var pageBudget: Int32?
    var spending: Int32?
    let SECTION_CATEGORY = 0
    weak var databaseController : DatabaseProtocol?
    let dateFormatter = DateFormatter()
    let CELL_CATEGORY = "categoryCell"
    let categories = ["Food","Bills","Transport","Groceries","Shopping","Others"]
    var thisCategory: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthText: UILabel!
    @IBOutlet weak var spendingText: UILabel!
    @IBOutlet weak var budgetText: UILabel!
    
    @IBAction func setBudget(_ sender: Any) {
        performSegue(withIdentifier: "setBudgetSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setBudgetSegue"{
            let destination = segue.destination as! SetBudgetViewController
            destination.delegate = self
        } else if segue.identifier == "viewCategorySegue"{
            let destination = segue.destination as! CategoryComparisonViewController
            destination.spendingCategory = thisCategory
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",
                                                     for: indexPath)
        var content = cell.defaultContentConfiguration()
        let date = Date()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM"
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: date)
        content.text = self.categories[indexPath.row]
        // Getting amount from last month and this month, and then getting the remainder value
        let amountThisMonth = databaseController?.fetchSpendingByDateAndCategory(month: String(currentMonth), year: String(currentYear), category: self.categories[indexPath.row]) ?? 0
        print(amountThisMonth)
        let amountLastMonth = databaseController?.fetchSpendingByDateAndCategory(month: String(currentMonth - 1), year: String(currentYear), category: self.categories[indexPath.row]) ?? 0
        print(amountLastMonth)
        var finalAmount = Int(amountLastMonth) - Int(amountThisMonth)
        if finalAmount < 0 {
            finalAmount = finalAmount * -1
            content.secondaryText = "- $\(finalAmount)"
        } else {
            content.secondaryText = "$\(finalAmount)"
        }
        if amountLastMonth > amountThisMonth {
            cell.textLabel?.textColor = UIColor(named: "GreenColour")
        } else {
            cell.textLabel?.textColor = UIColor(named: "RedColour")
        }
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tempCategory = categories[indexPath.row]
        thisCategory = tempCategory
        self.performSegue(withIdentifier: "viewCategorySegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
