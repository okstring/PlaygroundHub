//
//  TabsViewController.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController
import NSObject_Rx
import SnapKit

class TabsViewController: UITabBarController, ViewModelBindableType {
    var viewModel: TabsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        makeUI()
    }
    
    func makeUI() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        tabBar.addSubview(visualEffectView)
    }
    
    func bindViewModel() {
        let input = TabsViewModel.Input(trigger: rx.viewWillAppear.mapToVoid().asObservable())
        let _ = viewModel.transform(input: input)
        
        
    }
}

extension TabsViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewModel.selectedIndex.onNext(())
    }
}
