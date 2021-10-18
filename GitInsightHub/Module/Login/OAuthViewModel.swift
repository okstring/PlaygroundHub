//
//  OAuthViewModel.swift
//  GithubInsight
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import RxSwift
import RxCocoa
import AuthenticationServices

private let loginURL = URL(string: "http://github.com/login/oauth/authorize?client_id=\(Keys.github.appID)&scope=\(Configs.App.githubScope)")!
private let callbackURLScheme = "githubinsight"

class OAuthViewModel {
    struct Input {
        let oAuthLoginTrigger: Driver<Void>
    }
    
    struct Output {
        let oAuthLoginTrigger: Driver<Void>
    }
    
    private var session: ASWebAuthenticationSession?
    
    let code = PublishSubject<String>()
//
//    func transform(input: Input) -> Output {
//
//        input.oAuthLoginTrigger.drive(onNext: { [weak self] in
//            self?.session = ASWebAuthenticationSession(url: loginURL, callbackURLScheme: <#T##String?#>, completionHandler: <#T##ASWebAuthenticationSession.CompletionHandler##ASWebAuthenticationSession.CompletionHandler##(URL?, Error?) -> Void#>)
//        })
//
//
//
//        return
//    }
}
