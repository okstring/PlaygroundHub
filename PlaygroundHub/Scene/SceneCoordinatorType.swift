//
//  SceneCoordinatorType.swift
//  RxSidedish
//
//  Created by Issac on 2021/08/31.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func transition() -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
}
