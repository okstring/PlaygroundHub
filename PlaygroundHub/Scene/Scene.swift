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
            
            let transition = CATransition()
            transition.duration = 1.0
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.reveal
            tabsVC.view.layer.add(transition, forKey: nil)
            
            var trandVC = TrandViewController()
            let trandNav = UINavigationController(rootViewController: trandVC)
            let trandViewModel = TrandViewModel(title: "Find Star", usecase: viewModel.usecase, sceneCoordinator: viewModel.sceneCoordinator)
            trandVC.bind(viewModel: trandViewModel)
            trandVC.tabBarItem = UITabBarItem(title: "Find Star", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
            
            var profileVC = ProfileViewController()
            let profileNav = UINavigationController(rootViewController: profileVC)
            let profileViewModel = ProfileViewModel(title: "Profile", usecase: viewModel.usecase, sceneCoordinator: viewModel.sceneCoordinator)
            profileVC.bind(viewModel: profileViewModel)
            profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
            
            tabsVC.viewControllers = [trandNav, profileNav]
            
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
