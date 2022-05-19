//
//  BudgetViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 29/04/2022.
//

import UIKit

class BudgetViewController: UIViewController, SetBudgetDelegate {
    func setToBudget(_ budget: Int32) {
        budgetText.text = "$ \(String(budget))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    var budget: String?
    var spending: Int?
    

    @IBOutlet weak var monthText: UILabel!
    @IBOutlet weak var spendingText: UILabel!
    @IBOutlet weak var budgetText: UILabel!
    
    @IBAction func setBudget(_ sender: Any) {
        performSegue(withIdentifier: "setBudgetSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SetBudgetViewController
        destination.delegate = self
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
