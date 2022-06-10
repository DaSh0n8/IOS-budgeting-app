//
//  UserStatsViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 27/05/2022.
//

import UIKit
import Charts

class UserStatsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ChartViewDelegate {
    
    weak var databaseController : DatabaseProtocol?
    let categories = ["Food","Bills","Transport","Groceries","Shopping","Others","Total"]
    var pickerView = UIPickerView()
    var barChart = BarChartView()
    let formato: BarChartFormatter = BarChartFormatter()
    let xaxis: XAxis = XAxis()
    var chosenCategory : String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        pickerView.delegate = self
        pickerView.dataSource = self
        barChart.delegate = self
        
        categoryTextField.inputView = pickerView
        categoryTextField.textAlignment = .center
        categoryTextField.placeholder = "Select category"
        // Do any additional setup after loading the view.
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        var spendingsArray = [Int]()
//
//        barChart.frame = CGRect(x: 0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.width)
//        barChart.center = view.center
//        view.addSubview(barChart)
//
//        var entries = [BarChartDataEntry]()
//
////        var entries = [ChartDataEntry]()
////        for month in months{
////          entries.append(month)
//        let date = Date()
//        let calendar = Calendar.current
//        let currentYear = String(calendar.component(.year, from: date))
//
////        let customFormatter = BarChartFormatter()
////        customFormatter.months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
//
//        for x in 0..<12{
//            let monthVal = String(x + 1)
//            let val = databaseController?.fetchSpendingByDateAndCategory(month: monthVal, year: currentYear, category: "Food") ?? 0
//            entries.append(BarChartDataEntry(x: Double(x), y: Double(val)))
//            let _ = formato.stringForValue(Double(x), axis: xaxis)
//        }
//
//        xaxis.valueFormatter = formato
//
//        barChart.xAxis.setLabelCount(12, force: true)
//        barChart.xAxis.valueFormatter = xaxis.valueFormatter
//        barChart.xAxis.axisMinimum = -0.5
//
//        let set = BarChartDataSet(entries: entries)
//        set.colors = ChartColorTemplates.joyful()
//
//        let data = BarChartData(dataSet: set)
//
//        barChart.data = data
//    }
    
    
    @IBOutlet weak var categoryTextField: UITextField!

    
    @IBAction func loadGraph(_ sender: Any) {
        
        var spendingsArray = [Int]()

        barChart.frame = CGRect(x: 0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        barChart.center = view.center
        view.addSubview(barChart)
               
        var entries = [BarChartDataEntry]()
        
        let date = Date()
        let calendar = Calendar.current
        let currentYear = String(calendar.component(.year, from: date))
        // If total is selected
        if chosenCategory == "Total" {
            for x in 0..<12{
                let monthVal = String(x + 1)
                let val = databaseController?.fetchTotalEachMonth(month: monthVal, year: currentYear) ?? 0
                entries.append(BarChartDataEntry(x: Double(x), y: Double(val)))
                let _ = formato.stringForValue(Double(x), axis: xaxis)
            }
        } else {
            // If any other category is selected
            for x in 0..<12{
                let monthVal = String(x + 1)
                let val = databaseController?.fetchSpendingByDateAndCategory(month: monthVal, year: currentYear, category: chosenCategory ?? "Food") ?? 0
                entries.append(BarChartDataEntry(x: Double(x), y: Double(val)))
                let _ = formato.stringForValue(Double(x), axis: xaxis)
            }
        }
        // Formatting bar chart to show x axis values (the months)
        xaxis.valueFormatter = formato
        // Letting it show all 12 months otherwise it shows only 6
        barChart.xAxis.setLabelCount(12, force: true)
        barChart.xAxis.valueFormatter = xaxis.valueFormatter
        barChart.xAxis.axisMinimum = -0.5

        let set = BarChartDataSet(entries: entries, label: "")
        set.colors = ChartColorTemplates.joyful()
        
        let data = BarChartData(dataSet: set)
        
        barChart.data = data
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
        chosenCategory = categoryTextField.text
        categoryTextField.resignFirstResponder()
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
