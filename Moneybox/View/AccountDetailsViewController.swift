//
//  AccountDetailsViewController.swift
//  Moneybox
//
//  Created by Fernando Ives on 04/05/22.
//

import UIKit

enum AccountType: String {
    case Isa
    case Lisa
    static let isaString = "Individual Savings Account"
    static let lisaString = "Lifetime Individual Savings Account"
}

final class AccountDetailsViewController: UIViewController {
    
    private var accountHolderInfo: AccountHolderInformation?
    private let generalInfo: ProductResponses
    private let balanceViewModel = BalanceViewModel()
    private var product: Product
    
    private lazy var accountTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Heavy", size: 20)
        label.textColor = .paletteDarkBlue
        switch product.type {
        case AccountType.Isa.rawValue:
            label.text = "\(AccountType.isaString)"
        case AccountType.Lisa.rawValue:
            label.text = "\(AccountType.lisaString)"
        default:
            label.text = "Individual Account"
        }
        return label
    }()
    
    private lazy var accountNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Heavy", size: 20)
        label.textColor = .paletteDarkBlue
        label.text = product.name
        return label
    }()
    
    private lazy var planLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Heavy", size: 20)
        label.textColor = .paletteDarkBlue
        label.text = "Plan Value: £\(String(format: "%.2f", generalInfo.planValue))"
        return label
    }()
    
    private lazy var moneyboxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Heavy", size: 20)
        label.textColor = .paletteDarkBlue
        label.text = "Moneybox: £\(String(format: "%.2f", generalInfo.moneyBox))"
        return label
    }()

    private lazy var detailStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .red
        return stackView
    }()
    
    private lazy var addBalanceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addBalance), for: .touchUpInside)
        button.setTitle("Add Balance", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .mainColor
        return button
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
        view.backgroundColor = .white
        view.addSubview(detailStackview)
        detailStackview.addArrangedSubview(accountTypeLabel)
        detailStackview.addArrangedSubview(accountNameLabel)
        detailStackview.addArrangedSubview(planLabel)
        detailStackview.addArrangedSubview(moneyboxLabel)
        view.addSubview(addBalanceButton)
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            detailStackview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            detailStackview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailStackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            detailStackview.heightAnchor.constraint(equalToConstant: 150),
            addBalanceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            addBalanceButton.heightAnchor.constraint(equalToConstant: 50),
            addBalanceButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
            addBalanceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func addBalance(sender: UIButton) {
        print("Add 10 quid")
        balanceViewModel.addBalance()
    }
}
