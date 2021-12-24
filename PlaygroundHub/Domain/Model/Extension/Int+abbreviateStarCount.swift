//
//  Int+abbreviateStarCount.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2021/12/24.
//

import Foundation

extension Int {
    var abbreviateStarCount: String {
        let count = String(self).count
        if count > 4 {
            return "\(self / 1000)k"
        } else {
            return "\(self.decimal)"
        }
    }
}
