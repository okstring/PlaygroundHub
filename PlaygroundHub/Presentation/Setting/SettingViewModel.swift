//
//  SettingViewModel.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2022/02/08.
//

import Foundation

enum SettingSection: String, CaseIterable {
    case signOut = "Sign Out"
}

class SettingViewModel: ViewModel, ObservableObject {
    
    func logout() {
        AuthManager.shared.deleteToken()
        transitionOauthScene()
    }
    
    func transitionOauthScene() {
        let oauthViewModel = OAuthViewModel(usecase: usecase, sceneCoordinator: sceneCoordinator)
        let scene = Scene.oauth(oauthViewModel)
        
        sceneCoordinator.transition(to: scene, using: .root, animated: true)
    }
}
