//
//  AccountDetailsViewController.swift
//  Moneybox
//
//  Created by Fernando Ives on 04/05/22.
//

import UIKit
import ProgressHUD

enum AccountType: String {
    case Isa
    case Lisa
    static let isaString = "Individual Savings Account"
    static let lisaString = "Lifetime Individual Savings Account"
    static let defaultAccount = "Savings Account"
}

final class AccountDetailsViewController: UIViewController {
    
    private var accountHolderInfo: AccountHolderInformation?
    private let generalInfo: ProductResponses
    private let balanceViewModel = BalanceViewModel()
    private var product: Product
    private let tenPounds: Double = 10
    
    private lazy var accountTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.GeneralStrings.fontAvenir, size: 25)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = .mainColor
        switch product.type {
        case AccountType.Isa.rawValue:
            label.text = "\(AccountType.isaString)"
        case AccountType.Lisa.rawValue:
            label.text = "\(AccountType.lisaString)"
        default:
            label.text = AccountType.defaultAccount
        }
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var accountNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.GeneralStrings.fontAvenir, size: 20)
        label.textColor = .paletteDarkBlue
        label.text = product.name
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var planLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.GeneralStrings.fontAvenir, size: 20)
        label.textColor = .paletteDarkBlue
        label.text = Constants.AccountStrings.planValue + "\(String(format: "%.2f", generalInfo.planValue))"
        return label
    }()
    
    private lazy var moneyboxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.GeneralStrings.fontAvenir, size: 20)
        label.textColor = .paletteDarkBlue
        label.text = Constants.AccountStrings.moneybox + "\(String(generalInfo.moneyBox))"
        return label
    }()

    private lazy var detailStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        stackView.layer.shadowOffset = .zero
        stackView.layer.shadowRadius = 3
        stackView.layer.shadowColor = UIColor.white.cgColor
        stackView.layer.shadowOpacity = 0.5
        stackView.layer.masksToBounds = false
        stackView.layer.cornerRadius = 10
        return stackView
    }()
    
    private lazy var addBalanceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(makePayment), for: .touchUpInside)
        button.setTitle(Constants.AccountStrings.addTen, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .mainColor
        button.titleLabel?.font = UIFont(name: Constants.GeneralStrings.fontAvenir, size: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Images.moneyboxBird)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(generalInfo: ProductResponses, product: Product) {
        self.generalInfo = generalInfo
        self.product = product
        super.init(nibName: nil, bundle: nil)
        viewSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func viewSetup() {
        let gradientLayer = Utilities.makeGradient(topColor: .white, bottomColor: .lightMain)
        gradientLayer.frame = self.view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(detailStackview)
        detailStackview.addArrangedSubview(accountTypeLabel)
        detailStackview.addArrangedSubview(accountNameLabel)
        detailStackview.addArrangedSubview(planLabel)
        detailStackview.addArrangedSubview(moneyboxLabel)
        view.addSubview(imageView)
        view.addSubview(addBalanceButton)
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            //StackView
            detailStackview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            detailStackview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailStackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            detailStackview.heightAnchor.constraint(equalToConstant: 150),
            //Labels
            accountTypeLabel.leadingAnchor.constraint(equalTo: detailStackview.leadingAnchor, constant: 16),
            accountTypeLabel.trailingAnchor.constraint(equalTo: detailStackview.trailingAnchor, constant: -16),
            accountNameLabel.leadingAnchor.constraint(equalTo: detailStackview.leadingAnchor, constant: 16),
            accountNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: detailStackview.trailingAnchor, constant: -16),
            planLabel.leadingAnchor.constraint(equalTo: detailStackview.leadingAnchor, constant: 16),
            planLabel.trailingAnchor.constraint(greaterThanOrEqualTo: detailStackview.trailingAnchor, constant: -16),
            moneyboxLabel.leadingAnchor.constraint(equalTo: detailStackview.leadingAnchor, constant: 16),
            moneyboxLabel.trailingAnchor.constraint(greaterThanOrEqualTo: detailStackview.trailingAnchor, constant: -16),
            //ImageView
            imageView.topAnchor.constraint(greaterThanOrEqualTo: detailStackview.bottomAnchor, constant: 50),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            //Button
            addBalanceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addBalanceButton.heightAnchor.constraint(equalToConstant: 50),
            addBalanceButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
            addBalanceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func makePayment(sender: UIButton) {
        ProgressHUD.show()
        balanceViewModel.makePayment(tenPounds, generalInfo.id) { [weak self] newMoneyboxAmount, success in
            if success {
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    self?.moneyboxLabel.text = Constants.AccountStrings.moneybox + "\(String(newMoneyboxAmount))"
                }
            } else {
                self?.showMoneyAlert()
            }
        }
    }

    private func showMoneyAlert() {
        let alert = UIAlertController(title: Constants.AlertMessages.error, message: Constants.AlertMessages.moneyboxError,
                                   preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.AlertMessages.dismiss, style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
