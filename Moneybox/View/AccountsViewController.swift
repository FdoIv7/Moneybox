//
//  AccountsViewController.swift
//  Moneybox
//
//  Created by Fernando Ives on 03/05/22.
//

import UIKit

final class AccountsViewController: UIViewController {

    private var accountHolderInfo: AccountHolderInformation
    private let utilHelper = Utilities()

    private lazy var welcomeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        return stackView
    }()

    private lazy var helloLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Heavy", size: 15)
        label.text = "Hello Moneybox Team!"
        label.textColor = .paletteDarkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var planValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Heavy", size: 20)
        label.text = "Total Plan Value: £\(String(format: "%.2f", accountHolderInfo.totalPlanValue))"
        label.textColor = .paletteDarkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var accountsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: AccountTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    init(accountHolderInfo: AccountHolderInformation) {
        self.accountHolderInfo = accountHolderInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        accountsTableView.delegate = self
        accountsTableView.dataSource = self
        print("Products from accounts = \(accountHolderInfo.accountProducts)")
    }

    private func setupView() {
        let gradientLayer = Utilities.makeGradient(topColor: .white, bottomColor: .lightMain)
        gradientLayer.frame = self.view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(welcomeStackView)
        view.addSubview(accountsTableView)
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
        navigationController?.navigationBar.tintColor = .mainColor
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            welcomeStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            welcomeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            accountsTableView.topAnchor.constraint(equalTo: welcomeStackView.bottomAnchor, constant: 16),
            accountsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            accountsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            accountsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
}

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountHolderInfo.accountProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath)
                as? AccountTableViewCell else { return UITableViewCell () }
        let model = accountHolderInfo.accountProducts[indexPath.row]
        cell.configureCell(with: model, row: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generalInfo = accountHolderInfo.accountProducts[indexPath.row]
        let product = accountHolderInfo.accountProducts[indexPath.row].product
        let detailsController = AccountDetailsViewController(generalInfo: generalInfo, product: product)
        navigationController?.pushViewController(detailsController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
