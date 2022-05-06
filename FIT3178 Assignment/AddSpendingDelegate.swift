//
//  AddSpendingDelegate.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 05/05/2022.
//

import Foundation

protocol AddSpendingDelegate: AnyObject {
    func addSpending(_ newSpending: Spending) -> Bool
}
