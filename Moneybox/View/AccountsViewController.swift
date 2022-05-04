//
//  AccountsViewController.swift
//  Moneybox
//
//  Created by Fernando Ives on 03/05/22.
//

import UIKit

final class AccountsViewController: UIViewController {

    private var products: [ProductResponses]
    private var accountHolderInfo: AccountHolderInformation

    private lazy var welcomeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var helloLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Heavy", size: 20)
        label.text = "Hello Moneybox"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var planValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Heavy", size: 20)
        label.text = String(format: "%.2f", accountHolderInfo.totalPlanValue)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    init(accountHolderInfo: AccountHolderInformation, products: [ProductResponses]) {
        self.accountHolderInfo = accountHolderInfo
        self.products = products
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        print("Products from accounts = \(products)")
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(welcomeStackView)
        welcomeStackView.addArrangedSubview(helloLabel)
        welcomeStackView.addArrangedSubview(planValueLabel)
        setConstraints()
    }

    private func setupNavBar() {
        title = "Accounts"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainColor]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            welcomeStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            welcomeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            welcomeStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

}
