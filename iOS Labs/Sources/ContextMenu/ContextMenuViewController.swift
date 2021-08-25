//
//  ContextMenuViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 25.08.2021.
//

import UIKit

final class ContextMenuViewController: UIViewController { }

extension ContextMenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContextMenuCell", for: indexPath)
        cell.textLabel?.text = "Ячейка №\(indexPath.row)"
        return cell
    }
}

extension ContextMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let share = UIAction(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { [weak self] action in
                self?.showAlert("Отрабатываем действие Share")
            }

            let orderPizza = UIAction(
                title: "Order Pizza",
                image: nil,
                attributes: .disabled
            ) { [weak self] action in
                self?.showAlert("Отрабатываем действие Order Pizza")
            }

            let setInternational = UIAction(
                title: "International",
                image: nil,
                identifier: nil,
                discoverabilityTitle: nil,
                state: .on
            ) { [weak self] action in
                self?.showAlert("Отрабатываем действие Set International")
            }

            let setUK = UIAction(
                title: "UK",
                image: nil,
                identifier: nil,
                discoverabilityTitle: nil,
                state: .off
            ) { [weak self] action in
                self?.showAlert("Отрабатываем действие Set UK")
            }

            let unitsMenu = UIMenu(title: "Units", image: nil, options: .displayInline, children: [setInternational, setUK])

            return UIMenu(title: "Context Menu", image: nil, children: [share, orderPizza, unitsMenu])
        }
    }
}

extension ContextMenuViewController {

    private func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
