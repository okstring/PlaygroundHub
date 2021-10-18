//
//  Scene.swift
//  RxSidedish
//
//  Created by Issac on 2021/08/31.
//

import UIKit

enum Scene {
    case oauth(OAuthViewModel)
}

extension Scene {
    
    func instantiate() -> UIViewController {
        
        switch self {
        case .oauth(let viewModel):
            var oauthVC = OAuthViewController()
            oauthVC.view.backgroundColor = .white
            oauthVC.bind(viewModel: viewModel)
            return oauthVC
        }
    }
    
}
