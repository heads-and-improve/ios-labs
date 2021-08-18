//
//  SwipeActionsViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 18.08.2021.
//

import UIKit

final class SwipeActionsViewController: UITableViewController { }

extension SwipeActionsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeCell", for: indexPath)
        cell.textLabel?.text = "Ячейка №\(indexPath.row)"
        return cell
    }
}

extension SwipeActionsViewController {
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row % 2 == 0 else { return nil }

        let checkAction = UIContextualAction(style: .normal, title: "Check")
        { [weak self] action, view, completion in
            self?.showAlert(withMessage: "Отрабатываем действие Check")
            completion(true)
        }
        checkAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [checkAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row % 2 == 1 else { return nil }

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete")
        { [weak self] action, view, completion in
            self?.showAlert(withMessage: "Отрабатываем действие Delete")
            completion(true)
        }

        let editAction = UIContextualAction(style: .normal, title: "Edit")
        { [weak self] action, view, completion in
            self?.showAlert(withMessage: "Отрабатываем действие Edit")
            completion(true)
        }
        editAction.backgroundColor = .systemGreen

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true

        return configuration
    }
    
}

extension SwipeActionsViewController {

    private func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
