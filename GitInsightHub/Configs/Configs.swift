//
//  Configs.swift
//  GithubInsight
//
//  Created by Issac on 2021/10/18.
//

import Foundation

enum Keys {
    case github

    var apiKey: String {
        switch self {
        case .github: return "57710f4699c032e3dfc932bb3559137dde713e25"
        }
    }

    var appID: String {
        switch self {
        case .github: return "90474a077aa7122864e9"
        }
    }
}

struct Configs {
    struct App {
        static let githubScope = "user+repo+notifications+read:org"
        static let bundleIdentifier = "kr.maylily.GitInsightHub"
    }
    
}
