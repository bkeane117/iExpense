//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Brendan Keane on 2021-04-20.
//

import Foundation

// data type to repressent the expense
struct ExpenseItem: Identifiable, Codable {
    let id = UUID() //this is neccisary to make ExpenseItem an identifiable property
    let name: String // name of the expense
    let type: String // what type of expense it is
    let amount: Int // expense dollar amount
}

