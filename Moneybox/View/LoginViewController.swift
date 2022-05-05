//
//  ViewController.swift
//  Moneybox
//
//  Created by Fernando  Perez on 30/04/22.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let loginViewModel = LoginViewModel()
    private let accountInfoViewModel = AccountInfoViewModel()
    private var accountHolderInformation = AccountHolderInformation()
    
    private lazy var warningText: UILabel = {
        let label = UILabel()
        label.text = "Please enter your account information"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    private func setView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        setTextFields()
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
    }
    
    private func setTextFields() {
        passwordTextField.isSecureTextEntry = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func logginTapped(_ sender: UIButton) {
        getAccountInformation()
    }
    
    private func getAccountInformation() {
        guard let email = emailTextField.text, let password = passwordTextField.text,
              loginViewModel.validateCredentialsFormat(email, password) else {
            showLoginWarning()
            return
        }
        print("Email = \(email)")
        print("Password = \(password)")
        loginViewModel.login(email, password)
        if !APIService.shared.accountRequestSuccessful {
            showLoginError()
            return
        }

        accountInfoViewModel.getProducts { [weak self] products, total, success in
            guard let self = self else { return }
            if success {
                self.accountHolderInformation.accountProducts = products
                self.accountHolderInformation.totalPlanValue = total
                let accountsController = AccountsViewController(accountHolderInfo: self.accountHolderInformation)
                self.navigationController?.pushViewController(accountsController, animated: true)
            } else {
                self.showLoginError()
            }
        }
    }

    private func showLoginError() {
        let alert = UIAlertController(title: "Login Error", message: "Please try again",
                                      preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    private func showLoginWarning() {
        let alert = UIAlertController(title: "Enter your credentials", message: "Please enter all the information",
                                      preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard () {
        view.endEditing(true)
    }
}
