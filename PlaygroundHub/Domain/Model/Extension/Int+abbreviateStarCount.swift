//
//  Int+abbreviateStarCount.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2021/12/24.
//

import Foundation

extension Int {
    var abbreviateStarCount: String {
        let number = Double(self)
        let thousand = number / 1000
        
        if thousand >= 1.0 {
            return "\(round(thousand * 10) / 10)K"
        }
        else {
            return "\(self)"
        }
    }
}
