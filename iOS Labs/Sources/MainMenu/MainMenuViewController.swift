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
        guard let storyboardName = lessons[indexPath.row].storyboardName else { return }
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)

        let identifier: String
        switch indexPath.row {
        case 1:
            identifier = "SwipeActionsViewController"
            guard let viewController = storyboard
                    .instantiateViewController(identifier: identifier) as? SwipeActionsViewController
            else { return }
            navigationController?.pushViewController(viewController, animated: true)
            
        case 2:
            identifier = "ContextMenuViewController"
            guard let viewController = storyboard
                    .instantiateViewController(identifier: identifier) as? ContextMenuViewController
            else { return }
            navigationController?.pushViewController(viewController, animated: true)
        
        case 3:
            identifier = "GeneratePublishersViewController"
            guard let viewController = storyboard
                    .instantiateViewController(identifier: identifier) as? GeneratePublishersViewController
            else { return }
            navigationController?.pushViewController(viewController, animated: true)
        case 4:
            identifier = "CombineOperatorsViewController"
            guard let viewController = storyboard
                    .instantiateViewController(identifier: identifier) as? CombineOperatorsViewController
            else { return }
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }

}

extension MainMenuViewController {

    private enum Section {
        case main
    }

}
