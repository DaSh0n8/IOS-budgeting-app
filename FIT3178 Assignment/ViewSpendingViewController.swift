//
//  ViewSpendingViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 06/05/2022.
//

import UIKit
import CoreGraphics

class ViewSpendingViewController: UIViewController {

    var viewedSpending: Spending?
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        super.viewDidLoad()
        
        guard let viewedSpending = viewedSpending else {
            return
        }
        
        categoryText.text = viewedSpending.category
        dateText.text = dateFormatter.string(from: viewedSpending.date!)
        amountText.text = "$ \(viewedSpending.amount)"
        descriptionText.text = viewedSpending.desc
        
        // Giving the viewed categories their assigned colour
        if viewedSpending.category == "Food" {
            categoryView.backgroundColor = UIColor(named: "GreenColour")
        } else if viewedSpending.category == "Shopping" {
            categoryView.backgroundColor = UIColor(named: "PurpleColour")
        } else if viewedSpending.category == "Bills" {
            categoryView.backgroundColor = UIColor(named: "LightBlueColour")
        } else if viewedSpending.category == "Groceries" {
            categoryView.backgroundColor = UIColor(named: "RedColour")
        } else if viewedSpending.category == "Transport" {
            categoryView.backgroundColor = UIColor(named: "YellowColour")
        } else if viewedSpending.category == "Others" {
            categoryView.backgroundColor = UIColor(named: "BrownColour")
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var categoryText: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var amountText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
