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
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        let usecase = Usecase()
        
        #if DEBUG
        AuthManager.shared.deleteToken()
        #endif
        
        if AuthManager.shared.hasValidToken {
            
            let tabsViewModel = TabsViewModel(usecase: usecase, sceneCoordinator: sceneCoordinator)
            let tabsScene = Scene.tabs(tabsViewModel)
            
            sceneCoordinator.transition(to: tabsScene, using: .root, animated: false)
            
        } else {
            
            let oauthViewModel = OAuthViewModel(title: "", usecase: usecase, sceneCoordinator: sceneCoordinator)
            let oauthScene = Scene.oauth(oauthViewModel)
            
            sceneCoordinator.transition(to: oauthScene, using: .root, animated: false)
            
        }
        
    }
}

