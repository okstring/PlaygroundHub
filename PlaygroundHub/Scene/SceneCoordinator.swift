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
            guard let nav = currentVC as? UINavigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.pushViewController(target, animated: animated)
            
            subject.onCompleted()
            
            return subject.ignoreElements().asCompletable()
        }
        
        return subject.ignoreElements().asCompletable()
    }
    
    func transition() -> Completable {
        let subject = PublishSubject<Void>()
        
        guard let selectedVC = currentVC.tabBarController?.selectedViewController else {
            subject.onError(TransitionError.selectedViewControllerMissing)
            return subject.ignoreElements().asCompletable()
        }
        
        currentVC = selectedVC
        
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


