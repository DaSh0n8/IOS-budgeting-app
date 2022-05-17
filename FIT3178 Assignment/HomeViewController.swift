//
//  HomeViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 29/04/2022.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, DatabaseListener {
    
    let SECTION_SPENDING = 0
    let SECTION_INFO = 1
    let CELL_SPENDING = "spendingCell"
    let CELL_INFO = "totalCell"
    var allSpendings: [Spending] = []
    var filteredSpendings: [Spending] = []
    var spendingDetails : Spending?
    var listenerType = ListenerType.spending
    weak var databaseController : DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        filteredSpendings = allSpendings
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by category"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onAllSpendingsChange(change: DatabaseChange, spendings: [Spending]) {
        allSpendings = spendings
        updateSearchResults(for: navigationItem.searchController!)
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased()
        else {
            return
        }
        if searchText.count > 0 {
            filteredSpendings = allSpendings.filter({ (spending: Spending) -> Bool in
                return (spending.category?.lowercased().contains(searchText) ?? false)
            })
       } else {
           filteredSpendings = allSpendings
       }
        tableView.reloadData()
    }
    
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
            return filteredSpendings.count
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
            let spending = filteredSpendings[indexPath.row]
            content.text = "$ \(spending.amount ?? "0") "
            content.secondaryText = spending.category
            spendingCell.contentConfiguration = content
            
            return spendingCell
        }
        else {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath) as! SpendingCountTableViewCell
            infoCell.totalLabel?.text = "\(filteredSpendings.count) spendings this month"

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
            let spending = filteredSpendings[indexPath.row]
            databaseController?.deleteSpending(spending: spending)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisSpending = filteredSpendings[indexPath.row]
        spendingDetails = thisSpending
        self.performSegue(withIdentifier: "viewSpendingSegue", sender: self)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addSpending(_ sender: Any) {
        performSegue(withIdentifier: "addSpendingSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSpendingSegue" {
            let destination = segue.destination as! ViewSpendingViewController
            destination.viewedSpending = spendingDetails
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
}
