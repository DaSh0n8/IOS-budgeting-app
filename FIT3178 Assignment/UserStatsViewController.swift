//
//  UserStatsViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 27/05/2022.
//

import UIKit
import Charts

class UserStatsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ChartViewDelegate {
    

    let categories = ["Food","Bills","Transport","Groceries","Shopping","Others"]
    var pickerView = UIPickerView()
    var barChart = BarChartView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        barChart.delegate = self
        
        categoryTextField.inputView = pickerView
        categoryTextField.textAlignment = .center
        categoryTextField.placeholder = "Select category"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x: 0, y:0, width: 250, height: 200)
        barChart.center = view.center
        view.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        
        for x in categories {
            entries.append(BarChartDataEntry(x: Double(x) ?? 0, y: Double(x) ?? 0))
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        
        let data = BarChartData(dataSet: set)
        
        barChart.data = data
    }
    
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
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
