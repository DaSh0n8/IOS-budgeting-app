//
//  AddSpendingViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 29/04/2022.
//

import UIKit

class AddSpendingViewController: UIViewController {

    weak var spendingDelegate: AddSpendingDelegate?
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    
    
    @IBAction func createSpending(_ sender: Any) {
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateField.date
        
        guard let amount = amountTextField.text, let category = categoryTextField.text, let description = descriptionTextField.text else{
            return
        }
        if amount.isEmpty || category.isEmpty {
            var errorMsg = "Please ensure all fields are filled: \n"
            if amount.isEmpty{
                errorMsg += "Must provide amount \n"
            }
            if category.isEmpty{
                errorMsg += "Must provide category \n"
            }
            displayMessage(title: "Not all fields filled", message: errorMsg)
        }
        let spending = Spending (amount: amount, category: category, desc: description, date: date)
        let _ = spendingDelegate?.addSpending(spending)
        navigationController?.popViewController(animated: true)
    }
    
    func displayMessage(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
