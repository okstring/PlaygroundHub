//
//  UseCase.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import RxSwift


class Usecase: GithubAPI {
    let networking: Networking
    
    init(networking: Networking = Networking()) {
        self.networking = networking
    }
    
    func createAccessToken(clientId: String, clientSecret: String, code: String, redirectURI: String?) -> Single<Token> {
        return networking.createAccessToken(endpoint: Endpoint.createAccessToken(clientId: clientId, clientSecret: clientSecret, code: code, redirectURI: redirectURI))
    }
}