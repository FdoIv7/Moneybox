//
//  Product.swift
//  Moneybox
//
//  Created by Fernando Ives on 03/05/22.
//

import Foundation

struct ProductResponses: Codable {
    var id: Int
    var planValue: Double
    var moneyBox: Int
    var products: Product

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case planValue = "PlanValue"
        case moneyBox = "Moneybox"
        case products = "Product"
    }
}
