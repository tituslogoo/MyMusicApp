//
//  SceneDelegate.swift
//  MyMusicApp
//
//  Created by Titus Logo on 06/12/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let tabBarController: UITabBarController = UITabBarController()
        let homeVC: UIViewController = HomeViewController()
        let searchVC: UIViewController = SearchViewController()
        let myLibVC: UIViewController = MyLibraryViewController()
        
        var homeTabBarItem: UITabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "ic-home"),
            tag: 0
        )
        var searchTabBarItem: UITabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(named: "ic-search"),
            tag: 1
        )
        var myLibTabBarItem: UITabBarItem = UITabBarItem(
            title: "test",
            image: UIImage(named: "ic-library_white"),
            tag: 2
        )
        
        homeVC.tabBarItem = homeTabBarItem
        searchVC.tabBarItem = searchTabBarItem
        myLibVC.tabBarItem = myLibTabBarItem

        // Assign the view controllers to the tab bar controller
        tabBarController.viewControllers = [homeVC, searchVC, myLibVC]

        UITabBar.appearance().backgroundColor = ColorTool.darkPrimary
        UITabBar.appearance().tintColor = ColorTool.lightPrimary
        UITabBar.appearance().unselectedItemTintColor = ColorTool.darkSecondary
        
        // Set up the window and make the tab bar controller the root
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        }
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

