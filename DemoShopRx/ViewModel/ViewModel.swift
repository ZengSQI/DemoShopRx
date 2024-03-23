//
//  ViewModel.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/23.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
