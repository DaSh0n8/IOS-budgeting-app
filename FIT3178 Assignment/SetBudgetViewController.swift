//
//  SetBudgetViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 29/04/2022.
//

import UIKit

protocol SetBudgetDelegate: AnyObject{
    func setToBudget(_ budget: String)
}

class SetBudgetViewController: UIViewController {

    weak var delegate: SetBudgetDelegate? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var budgetTextField: UITextField!
    
    @IBAction func saveBudget(_ sender: Any) {
        let newBudget = budgetTextField.text
        delegate?.setToBudget(newBudget!)
        navigationController?.popViewController(animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let newBudget = Int(budgetTextField.text!) else{
//            return
//        }
//        if segue.identifier == "setBudgetSegue"{
//            let destination = segue.destination as! BudgetViewController
//            destination.budget = newBudget
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
