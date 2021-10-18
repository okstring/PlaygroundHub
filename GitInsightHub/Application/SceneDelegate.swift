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
        window?.makeKeyAndVisible()
        
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        let usecase = Usecase()
        let oauthViewModel = OAuthViewModel(usecase: usecase, sceneCoordinator: sceneCoordinator)
        
        let oauthScene = Scene.oauth(oauthViewModel)
        
        sceneCoordinator.transition(to: oauthScene, using: .root, animated: false)
        
    }
}

