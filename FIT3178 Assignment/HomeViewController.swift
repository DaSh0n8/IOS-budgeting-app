//
//  HomeViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 29/04/2022.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddSpendingDelegate {
    
    let SECTION_SPENDING = 0
    let SECTION_INFO = 1
    let CELL_SPENDING = "spendingCell"
    let CELL_INFO = "totalCell"
    var allSpendings: [Spending] = []
    var spendingDetails : Spending?
    weak var spendingDelegate: AddSpendingDelegate?
    
    func addSpending(_ newSpending: Spending) -> Bool {
        tableView.performBatchUpdates({
            allSpendings.append(newSpending)
            
            tableView.insertRows(at: [IndexPath(row: allSpendings.count - 1, section: SECTION_SPENDING)], with: .automatic)
        }, completion: nil)
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case SECTION_SPENDING:
            return allSpendings.count
        case SECTION_INFO:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_SPENDING{
            let spendingCell = tableView.dequeueReusableCell(withIdentifier: CELL_SPENDING, for: indexPath)
            var content = spendingCell.defaultContentConfiguration()
            let spending = allSpendings[indexPath.row]
            content.text = "$ \(spending.amount ?? "0") "
            content.secondaryText = spending.category
            spendingCell.contentConfiguration = content
            
            return spendingCell
        }
        else {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath) as! SpendingCountTableViewCell
            infoCell.totalLabel?.text = "\(allSpendings.count) spendings this month"

            return infoCell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section{
        case SECTION_SPENDING:
            return true
        case SECTION_INFO:
            return false
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_SPENDING{
            tableView.performBatchUpdates({
                if let index = self.allSpendings.firstIndex(of: allSpendings[indexPath.row]){
                    self.allSpendings.remove(at: index)
                }
                self.allSpendings.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadSections([SECTION_INFO], with: .automatic)
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisSpending = allSpendings[indexPath.row]
        spendingDetails = thisSpending
        self.performSegue(withIdentifier: "viewSpendingSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addSpending(_ sender: Any) {
        performSegue(withIdentifier: "addSpendingSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSpendingSegue" {
            let destination = segue.destination as! AddSpendingViewController
            destination.spendingDelegate = self
        } else if segue.identifier == "viewSpendingSegue"{
            let destination = segue.destination as! ViewSpendingViewController
            destination.viewedSpending = spendingDetails
        }
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
