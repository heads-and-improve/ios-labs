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
        guard let identifier = lessons[indexPath.row].viewControllerName else { return }

        switch indexPath.row {
        case 1:
            guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? SwipeActionsViewController else { return }
            navigationController?.pushViewController(viewController, animated: true)

        case 2:
            guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? ContextMenuViewController else { return }
            navigationController?.pushViewController(viewController, animated: true)

        case 3:
            guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? GeneratePublishersViewController else { return }
            navigationController?.pushViewController(viewController, animated: true)

        case 4:
            guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? CombineOperatorsViewController else { return }
            navigationController?.pushViewController(viewController, animated: true)

        case 5:
            guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? CombineErrorsViewController else { return }
            navigationController?.pushViewController(viewController, animated: true)
        
        case 6:
            guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? ThreeClosuresViewController else { return }
            navigationController?.pushViewController(viewController, animated: true)
            
        case 7:
            guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? CompositionalLayoutViewController else { return }
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
