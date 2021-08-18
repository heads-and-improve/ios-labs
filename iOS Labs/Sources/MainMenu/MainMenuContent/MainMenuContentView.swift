//
//  LessonContentView.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.08.2021.
//

import UIKit

final class MainMenuContentView: UIView, UIContentView {

    var configuration: UIContentConfiguration {
        didSet { update(for: configuration) }
    }

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    init(configuration: MainMenuCellContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        update(for: configuration)
        let stackView = UIStackView.mainMenu([titleLabel, descriptionLabel])
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func update(for configuration: UIContentConfiguration) {
        guard let configuration = configuration as? MainMenuCellContentConfiguration else { return }

        let font: UIFont
        switch configuration.state {
        case .normal:
            font = UIFont.systemFont(ofSize: 17.0)
        case .selected:
            font = UIFont.boldSystemFont(ofSize: 17.0)
        }

        titleLabel.font = font
        titleLabel.text = configuration.title

        descriptionLabel.font = UIFont.systemFont(ofSize: 12.0)
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = configuration.description
    }

}

fileprivate extension UIStackView {

    static func mainMenu(_ arrangedSubviews: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 4.0
        return stack
    }

}
