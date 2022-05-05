//
//  TextFieldValidators.swift
//  Moneybox
//
//  Created by Fernando  Perez on 30/04/22.
//

import Foundation

class TextFieldValidator {

    public func validateEmailTextField(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPrededicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPrededicate.evaluate(with: email)
    }
}
