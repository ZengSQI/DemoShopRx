//
//  CartItem.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/22.
//

import Foundation

struct CartItem: Hashable, Equatable {
    let id: UUID = .init()
    var item: ShopItem

    init(item: ShopItem) {
        self.item = item
    }
}
