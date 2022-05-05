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


    public func getProducts(completion: @escaping (_ products: [ProductResponses], _ total: Double, _ success: Bool) -> ()) {
        APIService.shared.getInvestorsProducts { products, total, success in
            completion(products, total, success)
        }
    }

    public func checkForError() -> Bool {
        return APIService.shared.accountRequestSuccessful
    }
}
