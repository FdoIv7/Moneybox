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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    private func setView() {
        let gradientLayer = Utilities.makeGradient(topColor: .white, bottomColor: .lightMain)
        gradientLayer.frame = self.view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
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
        showProgressHud()
        guard let email = emailTextField.text, let password = passwordTextField.text,
              loginViewModel.validateCredentialsFormat(email, password) else {
            showLoginWarning()
            dismissProgressHud()
            return
        }
        loginViewModel.login(email, password) { [weak self] accountHolderName in
            guard let self = self else { return }
            self.accountHolderInformation.name = accountHolderName ?? Constants.GeneralStrings.moneyboxTeam
            self.dismissProgressHud()
            if !APIService.shared.accountRequestSuccessful {
                self.showLoginError()
                return
            }
            self.accountInfoViewModel.getProducts { products, total, success in
                if success {
                    self.accountHolderInformation.accountProducts = products
                    self.accountHolderInformation.totalPlanValue = total
                    let accountsController = AccountsViewController(accountHolderInfo: self.accountHolderInformation)
                    self.navigationController?.pushViewController(accountsController, animated: true)
                } else {
                    self.showLoginError()
                }
            }
            self.dismissProgressHud()
        }
    }

    private func showProgressHud() {
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorAnimation = .mainColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            ProgressHUD.show()
        }
    }

    private func dismissProgressHud() {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }

    private func showLoginError() {
        let alert = UIAlertController(title: Constants.AlertMessages.loginError, message: Constants.AlertMessages.tryAgain,
                                      preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Constants.AlertMessages.ok, style: .default) { [weak self] action in
            self?.dismissProgressHud()
        }
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    private func showLoginWarning() {
        let alert = UIAlertController(title: Constants.AlertMessages.credentials, message: Constants.AlertMessages.correctInfo,
                                      preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Constants.AlertMessages.ok, style: .default) { [weak self] action in
            self?.dismissProgressHud()
        }
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
