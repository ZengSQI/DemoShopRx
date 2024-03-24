//
//  HistoryOrder.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/22.
//

import RxDataSources

struct HistoryOrder: Hashable, Equatable {
    var id: UUID = .init()
    var items: [CartItem]
}

extension HistoryOrder: SectionModelType {
    init(original: HistoryOrder, items: [CartItem]) {
        self = original
        self.items = items
    }
}
