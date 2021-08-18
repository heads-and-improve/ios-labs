//
//  LessonContentConfiguration.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.08.2021.
//

import UIKit

struct MainMenuCellContentConfiguration: UIContentConfiguration {

    private let lesson: Lesson

    private(set) var state: State

    var title: String? { lesson.title }
    var description: String? { lesson.description }

    init(lesson: Lesson) {
        self.lesson = lesson
        self.state = .normal
    }
    
    private init(lesson: Lesson, state: State) {
        self.lesson = lesson
        self.state = state
    }

    func makeContentView() -> UIView & UIContentView {
        MainMenuContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> MainMenuCellContentConfiguration {
        (state as? UICellConfigurationState)
            .flatMap { state in
                if state.isSelected {
                    return MainMenuCellContentConfiguration(lesson: lesson, state: .selected)
                } else {
                    return MainMenuCellContentConfiguration(lesson: lesson, state: .normal)
                }
            }
            ?? self
    }

}

extension MainMenuCellContentConfiguration: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(lesson)
    }

}

extension MainMenuCellContentConfiguration: Equatable {

    static func == (
        lhs: MainMenuCellContentConfiguration,
        rhs: MainMenuCellContentConfiguration
    ) -> Bool {
        lhs.lesson == rhs.lesson
    }

}

extension MainMenuCellContentConfiguration {
    
    enum State {
        case normal
        case selected
    }
    
}
