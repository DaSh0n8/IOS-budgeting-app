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
    // The months we show at the barchart's x axis
    var months: [String] = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    

    
    public override func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        return months[Int(value)]
    }
}
