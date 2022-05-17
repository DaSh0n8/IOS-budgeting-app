//
//  Spending.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 05/05/2022.
//

import UIKit

class Spending: NSObject {

    let amount: String?
    let category: String?
    let desc: String?
    let date: Date
    
    init(amount: String, category: String, desc: String, date: Date){
        self.amount = amount
        self.category = category
        self.desc = desc
        self.date = date
    }
}
