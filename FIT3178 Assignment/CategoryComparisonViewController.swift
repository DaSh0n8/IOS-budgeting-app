//
//  CategoryComparisonViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 27/05/2022.
//

import UIKit

class CategoryComparisonViewController: UIViewController {

    weak var databaseController : DatabaseProtocol?
    let dateFormatter = DateFormatter()
    var spendingCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let spendingCategory = spendingCategory else {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        let date = Date()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM"
        
        // Getting month and year components
        let calendar = Calendar.current
        let currentMonthInt = calendar.component(.month, from: date)
        let currentMonth = String(currentMonthInt)
    
        let currentYear = String(calendar.component(.year, from: date))
        let lastMonthInt = (calendar.component(.month, from: date)) - 1
        
        // Need to convert the months to strings because calendar.component gives Int values
        let prevMonth = String(lastMonthInt)
        let thisMonthString = currentYear + "-" + currentMonth
        let thisMonthDate = dateFormatter.date(from: thisMonthString)
        thisMonth.text = dateFormatter.string(from: thisMonthDate!)
        
        // Formatting last month's date
        let lastMonthString = currentYear + "-" + prevMonth
        let lastMonthDate = dateFormatter.date(from: lastMonthString)
        lastMonth.text = dateFormatter.string(from: lastMonthDate!)
        
        // Displaying both months' spending totals
        let thisMonthSpendingInt = databaseController?.fetchSpendingByDateAndCategory(month: currentMonth, year: currentYear, category: spendingCategory)
        let lastMonthSpendingInt = databaseController?.fetchSpendingByDateAndCategory(month: String(lastMonthInt), year: currentYear, category: spendingCategory)
        thisMonthSpending.text = String("Total spent this month: $ \(thisMonthSpendingInt!)")
        lastMonthSpending.text = String("Total spent last month: $ \(lastMonthSpendingInt!)")
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var thisMonth: UILabel!
    @IBOutlet weak var thisMonthSpending: UILabel!
    @IBOutlet weak var lastMonth: UILabel!
    @IBOutlet weak var lastMonthSpending: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
