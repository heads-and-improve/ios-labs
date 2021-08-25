//
//  MainMenuViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 07.08.2021.
//

import UIKit

final class MainMenuViewController: UITableViewController {

    var lessons: [Lesson] = []

    private lazy var dataSource = UITableViewDiffableDataSource<Section, MainMenuCellContentConfiguration>
        .init(tableView: tableView) { tableView, indexPath, configuration in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainMenuCell", for: indexPath)
            cell.contentConfiguration = configuration
            return cell
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        let configurations = lessons.map { MainMenuCellContentConfiguration(lesson: $0) }
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(configurations)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}
    
extension MainMenuViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "iOS Labs"
    }

}

extension MainMenuViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return }
        let storyboard: UIStoryboard
        let identifier: String
        switch indexPath.row {
        case 1:
            storyboard = UIStoryboard(name: "SwipeActions", bundle: nil)
            identifier = "SwipeActionsViewController"
            guard let viewController = storyboard
                    .instantiateViewController(identifier: identifier) as? SwipeActionsViewController
            else { return }
            navigationController?.pushViewController(viewController, animated: true)
            
        case 2:
            storyboard = UIStoryboard(name: "ContextMenu", bundle: nil)
            identifier = "ContextMenuViewController"
            guard let viewController = storyboard
                    .instantiateViewController(identifier: identifier) as? ContextMenuViewController
            else { return }
            navigationController?.pushViewController(viewController, animated: true)
        default:
            return
        }
    }

}

extension MainMenuViewController {

    private enum Section {
        case main
    }

}
