//
//  GithubAPI.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import RxSwift

protocol GithubAPI {
    
    func createAccessToken(clientId: String, clientSecret: String, code: String, redirectURI: String?) -> Single<Token>
    
    func getUser() -> Single<User>
    
    func getUserRepository() -> Single<[Repository]>
    
    func getStarred() -> Single<[Repository]>
    
    func getSearchRepositoryResult(query: String, page: Int) -> Single<[Repository]>
    
    func getRepsitory(name: String, repo: String) -> Single<Repository>
}
