//
//  ViewController.swift
//  Moneybox
//
//  Created by Fernando  Perez on 30/04/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    private var userEmail: String = ""
    private var userPass: String = ""
    let validators = TextFieldValidator()
    let loginViewModel = LoginViewModel()
    let apiService = APIService()

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
        apiService.urlRequest()
    }

    private func setView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        setTextFields()
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
    }

    private func setTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func logginTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text,
              loginViewModel.validateCredentialsFormat(email, password) else { return }
        //loginViewModel.login(email: String, pass: String)
        print("User = \(email)")
        print("Pass = \(password)")
        if let userText = emailTextField.text, let userPass = passwordTextField.text {

        } else {
            showLoginWarning()
        }
    }

    private func showLoginWarning() {
        print("Please enter your information")
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
