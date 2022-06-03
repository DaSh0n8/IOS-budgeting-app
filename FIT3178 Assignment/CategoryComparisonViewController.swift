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
        
        let calendar = Calendar.current
        let currentMonthInt = calendar.component(.month, from: date)
        let currentMonth = String(currentMonthInt)
        
        let currentYear = String(calendar.component(.year, from: date))
        let lastMonthInt = (calendar.component(.month, from: date)) - 1
        let prevMonth = String(lastMonthInt)
        let thisMonthString = currentYear + "-" + currentMonth
        let thisMonthDate = dateFormatter.date(from: thisMonthString)
        thisMonth.text = dateFormatter.string(from: thisMonthDate!)
        let lastMonthString = currentYear + "-" + prevMonth
        let lastMonthDate = dateFormatter.date(from: lastMonthString)
        lastMonth.text = dateFormatter.string(from: lastMonthDate!)
        let thisMonthSpendingInt = databaseController?.fetchSpendingByDateAndCategory(month: currentMonth, year: currentYear, category: spendingCategory)
        let lastMonthSpendingInt = databaseController?.fetchSpendingByDateAndCategory(month: String(lastMonthInt), year: currentYear, category: spendingCategory)
        thisMonthSpending.text = String(thisMonthSpendingInt!)
        lastMonthSpending.text = String(lastMonthSpendingInt!)
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
