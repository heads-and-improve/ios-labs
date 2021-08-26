//
//  ContextMenuViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 25.08.2021.
//

import UIKit

final class ContextMenuViewController: UIViewController {

    private let sightseeings = [
        Sightseeing(name: "Central park, Bolzano", imageName: "context-menu-bolzano-park"),
        Sightseeing(name: "Colosseum, Rome", imageName: "context-menu-rome-colosseum"),
        Sightseeing(name: "Santa Maria Novella church, Florence", imageName: "context-menu-florence-church"),
        Sightseeing(name: "Seceda mountain, Ortisei", imageName: "context-menu-ortisei-seceda"),
        Sightseeing(name: "Doge Palace, Venice", imageName: "context-menu-venice-palace"),
        Sightseeing(name: "Trees, Cortaccia", imageName: "context-menu-cortaccia-trees")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let viewController = storyboard?.instantiateViewController(identifier: "ContextMenuDetailsViewController") as? ContextMenuDetailsViewController
        else { return }
        viewController.sightseeing = sightseeings[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let sightseeing = sightseeings[indexPath.row]
        return UIContextMenuConfiguration(
            identifier: sightseeing.identifier as NSCopying,
//            identifier: sightseeing.imageName as NSCopying,
//            identifier: nil,
            previewProvider: { [weak self] in
                self?.storyboard
                    .flatMap{ $0.instantiateViewController(identifier: "ContextMenuPreviewViewController") }
                    .flatMap{ $0 as? ContextMenuPreviewViewController }
                    .flatMap{
                        $0.image = UIImage(named: "\(sightseeing.imageName)")
                        return $0
                    }
            }
//            previewProvider: nil
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
            
            let delete = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { [weak self] action in
                self?.showAlert("Отрабатываем действие Delete")
            }

            let setInternational = UIAction(
                title: "International",
                image: nil,
                identifier: nil,
                discoverabilityTitle: "Здесь мы описываем для чего нужен этот аргумент",
                state: .on
            ) { [weak self] action in
                self?.showAlert(action.discoverabilityTitle ?? "")
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

            return UIMenu(title: "Context Menu", image: nil, children: [share, orderPizza, unitsMenu, delete])
        }
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
//        guard let viewController = animator.previewViewController else { return }
        guard
            let viewController = storyboard?.instantiateViewController(identifier: "ContextMenuDetailsViewController") as? ContextMenuDetailsViewController,
            let identifier = configuration.identifier as? UUID
        else { return }
        print(identifier.uuidString)
        viewController.sightseeing = sightseeings.first(where: { $0.identifier == identifier })
        animator.addCompletion { [weak self] in
            self?.navigationController?.pushViewController(viewController, animated: true)
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
