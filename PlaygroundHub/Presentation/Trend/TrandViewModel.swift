//
//  TrandViewModel.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/19.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class TrandViewModel: ViewModel, ViewModelType {
    let disposeBag = DisposeBag()
    
    struct Input {
        let query: Observable<String>
        let pullRefresh: Observable<String>
        let nextPage: Observable<String>
    }
    
    struct Output {
        let title: Driver<String>
        let repository: BehaviorRelay<[Repository]>
        let isRefresh: Driver<Bool>
    }
    
    private var page = 1
    
    func transform(input: Input) -> Output {
        let title = title.asDriver(onErrorJustReturn: "")
        
        let repository = BehaviorRelay<[Repository]>(value: [Repository]())
        
        let refresh = BehaviorRelay<Bool>(value: false)
        
        Observable.of(input.query, input.pullRefresh)
            .merge()
            .map({ _ in true })
            .asDriver(onErrorJustReturn: false)
            .drive(refresh)
            .disposed(by: disposeBag)
            
        input.query
            .merge(with: input.pullRefresh)
            .do(onNext: { _ in self.page = 1 })
            .flatMap({ self.usecase.getSearchRepositoryResult(query: $0, page: self.page) })
            .do(onNext: { _ in refresh.accept(false) })
            .asDriver(onErrorJustReturn: [Repository]())
            .drive(repository)
            .disposed(by: disposeBag)
        
        input.nextPage
            .do(onNext: { _ in self.page += 1 })
            .flatMap({ self.usecase.getSearchRepositoryResult(query: $0, page: self.page) })
            .map({ repository.value + $0 })
            .do(onNext: { _ in refresh.accept(false) })
            .asDriver(onErrorJustReturn: [Repository]())
            .drive(repository)
            .disposed(by: disposeBag)
                
        let isRefresh = refresh.distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
                
        return Output(title: title, repository: repository, isRefresh: isRefresh)
    }
    
    lazy var detailAction: Action<Repository, Void> = {
        return Action { repository in
            
            let detailViewModel = DetailViewModel(title: "Detail", usecase: self.usecase, sceneCoordinator: self.sceneCoordinator, repository: repository)
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().mapToVoid()
        }
    }()
}
