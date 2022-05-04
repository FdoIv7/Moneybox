//
//  AccountInfoViewModel.swift
//  Moneybox
//
//  Created by Fernando Ives on 03/05/22.
//

import Foundation

final class AccountInfoViewModel {
    public func getAccounts(completion: @escaping (_ accounts: [Account]) -> ()) {
        APIService.shared.getAccounts { result in
            completion(result)
        }
    }

    public func getTotalPlanValue(completion: @escaping (_ total: Double) -> ()) {
        APIService.shared.getTotalPlanValue { total in
            completion(total)
        }
    }

    public func getProducts(completion: @escaping (_ products: [ProductResponses]) -> ()) {
        APIService.shared.getInvestorsProducts { products in
            completion(products)
        }
    }
}
