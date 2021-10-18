//
//  AuthManager.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import RxSwift
import RxCocoa
import KeychainAccess

let loggedIn = BehaviorRelay<Bool>(value: false)

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    fileprivate let tokenKey = "TokenKey"
    fileprivate let keychain = Keychain(service: Configs.App.bundleIdentifier)
    
    let tokenChanged = PublishSubject<Token?>()
    
    var token: Token? {
        get {
            guard let jsonString = keychain[tokenKey] else {
                return nil
            }
            guard let token: Token = CodableManager.shared.stringDecode(string: jsonString) else {
                return nil
            }
            return token
        }
        set {
            if let token = newValue, let tokenString = CodableManager.shared.encodeToString(object: token) {
                keychain[tokenKey] = tokenString
            } else {
                keychain[tokenKey] = nil
            }
            
            tokenChanged.onNext(newValue)
            loggedIn.accept(hasValidToken)
        }
    }
    
    class func setToken(_ token: Token) {
        AuthManager.shared.token = token
    }
    
    var hasValidToken: Bool {
        return token?.isValid == true
    }
}
