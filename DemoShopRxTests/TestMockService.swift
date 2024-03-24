//
//  TestMockService.swift
//  DemoShopRxTests
//
//  Created by Steven Zeng on 2024/3/24.
//

@testable import DemoShopRx
import RxSwift

class TestMockService: Service {
    var list: [ShopItem] = []
    var cart: [CartItem] = []
    var historyOrders: [HistoryOrder] = []

    func getList() -> Observable<[ShopItem]> {
        return .just(list)
    }

    func getCart() -> Observable<[CartItem]> {
        return .just(cart)
    }

    func addToCart(item: ShopItem) -> Observable<[CartItem]> {
        cart.append(CartItem(item: item))
        return .just(cart)
    }

    func deleteCart(item: CartItem) -> Observable<[CartItem]> {
        cart.removeAll(where: { $0 == item })
        return .just(cart)
    }

    func makeOrder(items: [CartItem]) -> Observable<HistoryOrder> {
        cart.removeAll(where: { items.contains($0) })
        let order = HistoryOrder(items: items)
        historyOrders.append(
            order
        )
        return .just(order)
    }

    func getHistoryOrders() -> Observable<[HistoryOrder]> {
        return .just(historyOrders)
    }
}
