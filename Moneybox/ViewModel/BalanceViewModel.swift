//
//  BalanceViewModel.swift
//  Moneybox
//
//  Created by Fernando Ives on 04/05/22.
//

import Foundation

final class BalanceViewModel {

    public func addBalance() {
        APIService.shared.addBalance()
    }
}
