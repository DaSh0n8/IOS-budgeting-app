//
//  BudgetViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 29/04/2022.
//

import UIKit

class BudgetViewController: UIViewController, SetBudgetDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func setToBudget(_ budget: Int32) {
        budgetText.text = "$ \(String(budget))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                               forCellReuseIdentifier: "CategoryCell")
        // Do any additional setup after loading the view.
    }
    
    var budget: String?
    var spending: Int?
    let SECTION_CATEGORY = 0
    let CELL_CATEGORY = "categoryCell"
    let categories = ["Food","Bills","Transport","Groceries","Shopping","Others"]
    
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
            //a
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",
                                                     for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = self.categories[indexPath.row]
        content.secondaryText = "$"
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewCategorySegue", sender: self)
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
