//
//  AnimationBaseViewController.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2022/01/09.
//

import UIKit
import SwiftUI
import RxSwift

class AnimationBaseViewController: UIViewController {
    let starredToast = PublishSubject<Bool>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        starredToast
            .subscribe(onNext: { isStarred in
                let vc = UIHostingController(rootView: StarredAnimationView(isStarred: isStarred))
                guard let alertToast = vc.view else {
                    return
                }
                alertToast.center = self.view.center
                self.view.addSubview(alertToast)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIView.animate(withDuration: 0.3) {
                        alertToast.alpha = 0
                    } completion: { _ in
                        alertToast.removeFromSuperview()
                    }
                }
            }).disposed(by: rx.disposeBag)
        
    }
}
