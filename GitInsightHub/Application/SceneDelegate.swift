//
//  SceneDelegate.swift
//  GithubInsight
//
//  Created by Issac on 2021/10/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIViewController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        let usecase = Usecase()
        
        #if DEBUG
        AuthManager.shared.deleteToken()
        #endif
        
        let tabsViewModel = TabsViewModel(authorized: AuthManager.shared.hasValidToken, usecase: usecase, sceneCoordinator: sceneCoordinator)
        
        let tabsScene = Scene.tabs(tabsViewModel)
        
        sceneCoordinator.transition(to: tabsScene, using: .root, animated: false)
        
    }
}

