//
//  LoginViewModel.swift
//  Moneybox
//
//  Created by Fernando  Perez on 01/05/22.
//

import Foundation

protocol LoginViewModelProtocol {
    
}

class LoginViewModel {
    let textfieldValidator = TextFieldValidator()

    func validateCredentialsFormat(_ email: String, _ password: String) -> Bool {
        if !email.isEmpty {
            return textfieldValidator.validateEmailTextField(email)
        }
        return false
    }

    func login(_ email: String, _ password: String) {
        
    }
    
}
