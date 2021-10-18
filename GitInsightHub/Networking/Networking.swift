//
//  Networking.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class NetworkManager {
    func get<T: Decodable>(type: T.Type,
                           endpoint: Endpoint,
                           needToken: Bool = false) -> Single<T> {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return Single.create() { single in
            AF.request(endpoint.URL,
                       method: endpoint.httpMethod,
                       parameters: endpoint.parameters,
                       encoding: URLEncoding.default,
                       headers: endpoint.headers,
                       interceptor: nil,
                       requestModifier: nil)
                .responseDecodable(of: type,
                                   decoder: decoder) { (dataResponse) in
                    guard let statusCode = dataResponse.response?.statusCode else {
                        return single(.failure(NetworkError.internet))
                    }
                    switch statusCode {
                    case 200..<300:
                        guard let result = dataResponse.value else {
                            return single(.failure(NetworkError.noResult))
                        }
                        single(.success(result))
                    case 300..<400:
                        single(.failure(NetworkError.redirection))
                    case 400..<500:
                        single(.failure(NetworkError.notAllowed))
                    case 500...:
                        single(.failure(NetworkError.server))
                    default:
                        single(.failure(NetworkError.unknown))
                    }
                }
            return Disposables.create()
        }
    }
    
    func createAccessToken(clientId: String, clientSecret: String, code: String, redirectURI: String?) -> Single<Token> {
        return Single.create { single in
            var params: Parameters = [:]
            params["client_id"] = clientId
            params["client_secret"] = clientSecret
            params["code"] = code
            params["redirect_uri"] = redirectURI
            AF.request("https://github.com/login/oauth/access_token",
                       method: .post,
                       parameters: params,
                       encoding: URLEncoding.default,
                       headers: ["Accept": "application/json"])
                .responseDecodable(of: Token.self, completionHandler: { response in
                    if let error = response.error {
                        single(.failure(error))
                        return
                    }
                    if let token = response.value {
                        single(.success(token))
                        return
                    }
                    single(.failure(RxError.unknown))
                })
            return Disposables.create()
        }
        .observe(on: MainScheduler.instance)
    }
}

