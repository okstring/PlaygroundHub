//
//  Token.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation

struct Token: Codable {

    var accessToken: String
    var scope: String?
    var tokenType: String?
    
    var isValid: Bool {
        return accessToken == ""
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}
