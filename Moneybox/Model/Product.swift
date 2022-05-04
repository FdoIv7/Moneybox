//
//  Product.swift
//  Moneybox
//
//  Created by Fernando Ives on 03/05/22.
//

import Foundation

struct Product: Codable {

    var name: String
    var type: String

    private enum CodingKeys: String, CodingKey {
        case name = "FriendlyName"
        case type = "Type"
    }
}
