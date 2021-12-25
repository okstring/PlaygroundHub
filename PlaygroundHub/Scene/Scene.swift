//
//  Scene.swift
//  RxSidedish
//
//  Created by Issac on 2021/08/31.
//

import UIKit

enum Scene {
    case oauth(OAuthViewModel)
    case tabs(TabsViewModel)
    case profile(ProfileViewModel)
    case detail(DetailViewModel)
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
            profileVC.bind(viewModel: viewModel)
            
            return profileVC
        case .detail(let viewModel):
            var detailVC = DetailViewController()
            detailVC.bind(viewModel: viewModel)
            
            return detailVC
        }
    }
    
}
