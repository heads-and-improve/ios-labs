//
//  ContextMenuViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 25.08.2021.
//

import UIKit

final class ContextMenuViewController: UIViewController {

    private var sightseeings = [
        Sightseeing(name: "Central park, Bolzano", image: UIImage(named: "context-menu-bolzano-park")),
        Sightseeing(name: "Colosseum, Rome", image: UIImage(named: "context-menu-rome-colosseum")),
        Sightseeing(name: "Santa Maria Novella church, Florence", image: UIImage(named: "context-menu-florence-church")),
        Sightseeing(name: "Seceda mountain, Ortisei", image: UIImage(named: "context-menu-ortisei-seceda")),
        Sightseeing(name: "Doge Palace, Venice", image: UIImage(named: "context-menu-venice-palace")),
        Sightseeing(name: "Trees, Cortaccia", image: UIImage(named: "context-menu-cortaccia-trees"))
    ]

}

extension ContextMenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sightseeings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContextMenuCell", for: indexPath)
        let sightseeing = sightseeings[indexPath.row]
        cell.textLabel?.text = sightseeing.name
        return cell
    }
}

extension ContextMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let sightseeing = sightseeings[indexPath.row]
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] in
                self?.storyboard
                    .flatMap{ $0.instantiateViewController(identifier: "ContextMenuPreviewViewController") }
                    .flatMap{ $0 as? ContextMenuPreviewViewController }
                    .flatMap{
                        $0.image = sightseeing.image
                        return $0
                    }
            }
        ) { suggestedActions in

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
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            print("ASDF 2")
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
