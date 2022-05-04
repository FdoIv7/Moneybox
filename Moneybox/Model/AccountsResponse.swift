//
//  InvestorsResponse.swift
//  Moneybox
//
//  Created by Fernando Ives on 02/05/22.
//

import Foundation

struct AccountsResponse: Codable {
    var accounts: Account

    private enum CodingKeys: String, CodingKey {
        case accounts = "Accounts"
    }
}

