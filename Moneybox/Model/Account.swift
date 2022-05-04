//
//  Account.swift
//  Moneybox
//
//  Created by Fernando Ives on 02/05/22.
//

import Foundation

struct Account: Codable {
    var type: String
    var name: String
    var hasCollections: Bool

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case name = "Name"
        case hasCollections = "HasCollections"
        //case totalValue = "TotalValue"
    }
}
