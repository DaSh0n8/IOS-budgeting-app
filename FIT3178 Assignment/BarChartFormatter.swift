//
//  BarChartFormatter.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 08/06/2022.
//

import Foundation
import UIKit
import Charts

class BarChartFormatter: IndexAxisValueFormatter {
    var months: [String] = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    

    
    public override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
//        let count = self.months.count
//        guard let axis = axis, count > 0 else{
//            return ""
//        }
//
//        let factor = axis.axisMaximum / Double(count)
//
//        let index = Int((value / factor).rounded())
//
//        if index >= 0 && index < count {
//            return self.months[index]
//        }
//        return ""
//
        
        
        //return months[Int(value) % months.count]
        return months[Int(value)]
    }
}
