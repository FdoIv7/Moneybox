//
//  AccountTableViewCell.swift
//  Moneybox
//
//  Created by Fernando Ives on 04/05/22.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    static let identifier = "AccountTableViewCell"

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var accountNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Heavy", size: 20)
        label.textColor = .white
        return label
    }()

    private lazy var planValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Heavy", size: 15)
        label.textColor = .white
        return label
    }()

    private lazy var moneyboxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Heavy", size: 15)
        label.textColor = .white
        return label
    }()

    public func configureCell(with model: ProductResponses, row: Int) {
        if row % 2 == 0 {
            mainStackView.backgroundColor = .mainColor
            planValueLabel.textColor = .paletteDarkBlue
            moneyboxLabel.textColor = .paletteDarkBlue
            tintColor = .paletteDarkBlue
        } else {
            mainStackView.backgroundColor = .paletteDarkBlue
            accountNameLabel.textColor = .mainColor
            tintColor = .white
        }
        accountNameLabel.text = model.product.name
        planValueLabel.text = "Plan Value: £\(String(format: "%.2f", model.planValue))"
        moneyboxLabel.text = "Moneybox: \(String("£\(model.moneyBox)"))"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setView() {
        cellAppearanceSetup()
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(accountNameLabel)
        mainStackView.addArrangedSubview(planValueLabel)
        mainStackView.addArrangedSubview(moneyboxLabel)
        setConstraints()
    }

    private func cellAppearanceSetup() {
        backgroundColor = .clear
        if let image = UIImage(systemName: "chevron.right") {
            let checkMark = UIImageView(frame:CGRect(x:0, y:0, width:(image.size.width), height:(image.size.height)))
            checkMark.image = image
            accessoryView = checkMark
        }
    }
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
