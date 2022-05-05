//
//  LoginViewModel.swift
//  Moneybox
//
//  Created by Fernando  Perez on 01/05/22.
//

import Foundation

final class LoginViewModel {
    let textfieldValidator = TextFieldValidator()

    func validateCredentialsFormat(_ email: String, _ password: String) -> Bool {
        if !email.isEmpty {
            return textfieldValidator.validateEmailTextField(email)
        }
        return false
    }

    public func login(_ email: String, _ password: String, completion: @escaping (_ accountHolderName: String?) -> ()) {
        APIService.shared.login(email, password) { accountHolderName in
            completion(accountHolderName)
        }
    }
}
