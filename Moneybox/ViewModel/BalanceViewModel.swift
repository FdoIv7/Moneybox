//
//  BalanceViewModel.swift
//  Moneybox
//
//  Created by Fernando Ives on 04/05/22.
//

import Foundation

final class BalanceViewModel {

    public func makePayment(_ amount: Double, _ productId: Int, completion: @escaping (_ newMoneyboxAmount: Int, _ success: Bool) -> ()) {
        APIService.shared.makePayment(amount: amount, productId: productId) { newMoneyboxAmount, success in
            completion(newMoneyboxAmount, success)
        }
    }
}
