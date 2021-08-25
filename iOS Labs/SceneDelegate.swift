//
//  SceneDelegate.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 07.08.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene  = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let lessons = getLessons(fromPlist: "lessons")
        start(lessons: lessons, inWindow: window, withScene: scene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {

    private func getLessons(fromPlist plistName: String) -> [Lesson] {
        Bundle.main.url(forResource: plistName, withExtension: "plist")
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil) }
            .flatMap { $0 as? [Dictionary<String, String>] }
            .flatMap { unparsedLessons -> [Lesson] in
                unparsedLessons.compactMap { unparsedLesson in
                    let title = unparsedLesson["title"]
                    let description = unparsedLesson["description"]
                    let storyboardName = unparsedLesson["storyboardName"]
                    let viewControllerName = unparsedLesson["viewControllerName"]
                    return Lesson(
                        title: title,
                        description: description,
                        storyboardName: storyboardName,
                        viewControllerName: viewControllerName
                    )
                }
            }
            ?? []
    }

    private func start(lessons: [Lesson], inWindow window: UIWindow?, withScene scene: UIScene) {
        let mainMenuStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
        let identifier = "MainMenuViewController"
        guard let mainMenuViewController = mainMenuStoryboard
                .instantiateViewController(identifier: identifier) as? MainMenuViewController
        else { return }
        mainMenuViewController.lessons = lessons
        let navigationController = UINavigationController(rootViewController: mainMenuViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}
