//
//  SceneCoordinator.swift
//  RxSidedish
//
//  Created by Issac on 2021/08/31.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    var sceneViewController: UIViewController {
        return self.children.first ?? self
    }
}

final class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        
        let target = scene.instantiate()
        switch style {
        case .root:
            currentVC = target.sceneViewController
            
            window.rootViewController = target
            subject.onCompleted()
        case .push:
            if let tvc = currentVC as? TabsViewController {
                
                if let nc = tvc.selectedViewController as? UINavigationController,
                   let vc = nc.topViewController {
                    currentVC = vc
                    
                } else if let vc = tvc.selectedViewController {
                    currentVC = vc
                    
                } else {
                    subject.onError(TransitionError.selectedViewControllerMissing)
                    break
                }
            }
            
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.rx.willShow
                .subscribe(onNext: { [unowned self] event in
                    self.currentVC = event.viewController.sceneViewController
                })
                .disposed(by: bag)
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            
            subject.onCompleted()
            
            return subject.ignoreElements().asCompletable()
        }
        
        return subject.ignoreElements().asCompletable()
    }
    
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] (completable) in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.connotPop))
                    return Disposables.create()
                }
                
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
}


