//
//  OAuthViewModel.swift
//  GithubInsight
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import AuthenticationServices

private let loginURL = URL(string: "https://github.com/login/oauth/authorize?client_id=\(Keys.github.appID)&scope=\(Configs.App.githubScope)")!
private let callbackURLScheme = "playgroundhub"

class OAuthViewModel: ViewModel, ViewModelType {
    let disposeBag = DisposeBag()
    
    struct Input {
        let oAuthLoginTrigger: Driver<Void>
        let tappedDemo: Driver<Void>
    }
    
    struct Output {
        
    }
    
    private var session: ASWebAuthenticationSession?
    
    let code = PublishSubject<String>()
    let tokenSaved = PublishSubject<Void>()
    
    func transform(input: Input) -> Output {
        let usecase = usecase
        let sceneCoordinator = sceneCoordinator
        
        input.oAuthLoginTrigger.drive(onNext: { [weak self] in
            
            self?.session = ASWebAuthenticationSession(url: loginURL, callbackURLScheme: callbackURLScheme, completionHandler: { callbackURL, error in
                
                if let code = callbackURL?.queryParameters?["code"] {
                    self?.code.onNext(code)
                }
            })
            self?.session?.presentationContextProvider = self
            self?.session?.prefersEphemeralWebBrowserSession = true
            #if DEBUG
            self?.session?.prefersEphemeralWebBrowserSession = true
            #endif
            self?.session?.start()
        }).disposed(by: disposeBag)
        
        let tokenRequest = code.flatMapLatest { (code) -> Observable<RxSwift.Event<Token>> in
            let clientId = Keys.github.appID
            let clientSecret = Keys.github.apiKey
            
            return usecase.createAccessToken(clientId: clientId,
                                                  clientSecret: clientSecret,
                                                  code: code,
                                                  redirectURI: nil)
                .asObservable()
                .materialize()
        }.share()
        
        tokenRequest.elements().subscribe(onNext: { [weak self] (token) in
            AuthManager.setToken(token)
            self?.tokenSaved.onNext(())
        }).disposed(by: disposeBag)
        
        
        tokenSaved.subscribe(onNext: {
            let tabsViewModel = TabsViewModel(usecase: usecase, sceneCoordinator: sceneCoordinator)
            sceneCoordinator.transition(to: .tabs(tabsViewModel), using: .root, animated: true)
        }).disposed(by: rx.disposeBag)
        
        let demoDateComponent = DateComponents(year: 2021, month: 1, day: 1)
        let calendar = Calendar.current
        
        if let demoDate = calendar.date(from: demoDateComponent) {
            input.tappedDemo
                .filter({ Date() < demoDate })
                .drive(onNext: { [weak self] in
                    AuthManager.setToken(Token(accessToken: "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", scope: nil, tokenType: nil))
                    self?.tokenSaved.onNext(())
                }).disposed(by: rx.disposeBag)
            
        }
        
        return Output()
    }
}

extension OAuthViewModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first(where: \.isKeyWindow)
        return window ?? ASPresentationAnchor()
    }
}
