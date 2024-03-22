//
//  HistoryOrder.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/22.
//

import Foundation

struct HistoryOrder: Hashable, Equatable {
    let id: UUID = .init()
    let items: [CartItem]
}
