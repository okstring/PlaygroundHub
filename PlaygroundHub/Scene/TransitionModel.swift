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
}

enum TabBarIndex: Int {
    case trend = 0
    case profile
}

enum TransitionError: Error {
    case navigationControllerMissing
    case connotPop
    case unknown
    case tabBarControllerMissing
    case selectedViewControllerMissing
}
