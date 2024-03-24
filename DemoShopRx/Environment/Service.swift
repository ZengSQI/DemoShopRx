//
//  Service.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/23.
//

import RxSwift

protocol Service {
    func getList() -> Observable<[ShopItem]>
    func getCart() -> Observable<[CartItem]>
    func addToCart(item: ShopItem) -> Observable<[CartItem]>
    func deleteCart(item: CartItem) -> Observable<[CartItem]>
    func makeOrder(items: [CartItem]) -> Observable<HistoryOrder>
    func getHistoryOrders() -> Observable<[HistoryOrder]>
}

class AppService: Service {
    func getList() -> Observable<[ShopItem]> {
        return .empty()
    }

    func getCart() -> Observable<[CartItem]> {
        return .empty()
    }

    func addToCart(item _: ShopItem) -> Observable<[CartItem]> {
        return .empty()
    }

    func deleteCart(item _: CartItem) -> Observable<[CartItem]> {
        return .empty()
    }

    func makeOrder(items _: [CartItem]) -> Observable<HistoryOrder> {
        return .empty()
    }

    func getHistoryOrders() -> Observable<[HistoryOrder]> {
        return .empty()
    }
}

class MockService: Service {
    var list = ShopItem.testObjects
    var cart: [CartItem] = ShopItem.testObjects.prefix(2).map { CartItem(item: $0) }
    var historyOrders: [HistoryOrder] = [
        HistoryOrder(items: ShopItem.testObjects.prefix(3).map { CartItem(item: $0) }),
        HistoryOrder(items: ShopItem.testObjects.prefix(1).map { CartItem(item: $0) }),
    ]

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
