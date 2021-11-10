//
//  ViewModelType.swift
//  GithubInsight
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class ViewModel: NSObject {
    let usecase: GithubAPI
    let sceneCoordinator: SceneCoordinatorType
    let title: Driver<String>
    
    init(title: String = "", usecase: GithubAPI, sceneCoordinator: SceneCoordinatorType) {
        self.usecase = usecase
        self.sceneCoordinator = sceneCoordinator
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
    }
}
