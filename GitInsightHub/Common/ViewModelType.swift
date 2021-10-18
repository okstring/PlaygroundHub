//
//  ViewModelType.swift
//  GithubInsight
//
//  Created by Issac on 2021/10/18.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class ViewModel: NSObject {
    let usecase: GithubAPI
    let sceneCoordinator: SceneCoordinatorType
    
    init(usecase: GithubAPI, sceneCoordinator: SceneCoordinatorType) {
        self.usecase = usecase
        self.sceneCoordinator = sceneCoordinator
    }
}
