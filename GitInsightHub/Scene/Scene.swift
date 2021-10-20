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
}

extension Scene {
    
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
        }
    }
    
}
