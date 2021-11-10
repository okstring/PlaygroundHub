//
//  TransitionModel.swift
//  RxSidedish
//
//  Created by Issac on 2021/08/31.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case changeTabBarItem
}

enum TransitionError: Error {
    case navigationControllerMissing
    case connotPop
    case unknown
    case tabBarControllerMissing
}
