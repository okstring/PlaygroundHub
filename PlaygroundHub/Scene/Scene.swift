//
//  Scene.swift
//  RxSidedish
//
//  Created by Issac on 2021/08/31.
//

import UIKit

enum Scene {
    case tabs(TabsViewModel)
    case oauth(OAuthViewModel)
    case profile(ProfileViewModel)
}

extension Scene {
    var tabBarIndex: Int {
        switch self {
        case .oauth:
            return 0
        case .profile:
            return 1
        default:
            return 2
        }
    }
    
    func instantiate() -> UIViewController {
        
        switch self {
            
        case .tabs(let viewModel):
            var tabsVC = TabsViewController()
            tabsVC.bind(viewModel: viewModel)
            
            return tabsVC
        case .oauth(let viewModel):
            var oauthVC = OAuthViewController()
            oauthVC.bind(viewModel: viewModel)
            
            return oauthVC
        case .profile(let viewModel):
            var profileVC = ProfileViewController()
            let navVC = UINavigationController.init(rootViewController: profileVC)
            profileVC.bind(viewModel: viewModel)
            
            return navVC
        }
    }
    
}
