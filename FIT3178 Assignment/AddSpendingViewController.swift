//
//  AddSpendingViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 29/04/2022.
//

import UIKit

class AddSpendingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var databaseController: DatabaseProtocol?
    let dateFormatter = DateFormatter()
    var totalSpending: Int32 = 0
    let categories = ["Food","Bills","Transport","Groceries","Shopping","Others"]
    var pickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        categoryTextField.inputView = pickerView
        categoryTextField.textAlignment = .center
        categoryTextField.placeholder = "Select category"
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
        
        guard let amount: Int32 = Int32(amountTextField.text!), let category = categoryTextField.text, let description = descriptionTextField.text else{
            return
        }
        // Validation for input fields
        if category.isEmpty || String(amount).isEmpty {
            var errorMsg = "Please ensure all fields are filled: \n"
            if category.isEmpty{
                errorMsg += "Must provide category \n"
            }
            if String(amount).isEmpty {
                errorMsg += "Must provide amount \n"
            }
            displayMessage(title: "Not all fields filled", message: errorMsg)
        }
        let _ = databaseController?.addSpending(amount: amount, category: category, desc: description, date: date)
        totalSpending += amount
        navigationController?.popViewController(animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
        categoryTextField.resignFirstResponder()
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
