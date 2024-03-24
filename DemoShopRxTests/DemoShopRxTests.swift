//
//  DemoShopRxTests.swift
//  DemoShopRxTests
//
//  Created by Steven Zeng on 2024/3/22.
//

import XCTest
import RxTest
import RxSwift
@testable import DemoShopRx

final class DemoShopRxTests: XCTestCase {

    var disposeBag: DisposeBag!
    var service: TestMockService!
    var environment: Environment!
    var scheduler: TestScheduler!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        service = TestMockService()
        environment = Environment(service: service)
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShopListViewModel() {
        let viewModel = ShopListViewModel(environment: environment)
        let items = ShopItem.testObjects
        service.list = items

        let observer = scheduler.createObserver([ShopItem].self)
        let observable = scheduler.createHotObservable([
            .next(1, ())
        ])

        let output = viewModel.transform(
            input: ShopListViewModel.Input(
                loadTrigger: observable
                    .asDriver(onErrorJustReturn: ())
            )
        )

        output.items
            .subscribe(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(observer.events, [
            .next(0, []),
            .next(1, items)
        ])
    }

    func testItemDetailViewModel() {
        let item = ShopItem.testObjects[0]
        let viewModel = ItemDetailViewModel(environment: environment, item: item)

        let itemObserver = scheduler.createObserver(ShopItem.self)
        let addedObserver = scheduler.createObserver(Void.self)
        let addObservable = scheduler.createHotObservable([
            .next(1, ()),
            .next(2, ())
        ])

        let output = viewModel.transform(
            input: ItemDetailViewModel.Input(
                addToCart: addObservable
                    .asDriver(onErrorJustReturn: ())
            )
        )

        output.item
            .subscribe(itemObserver)
            .disposed(by: disposeBag)

        output.added
            .subscribe(addedObserver)
            .disposed(by: disposeBag)

        XCTAssertEqual(addedObserver.events.count, 0)
        scheduler.start()

        XCTAssertEqual(itemObserver.events, [
            .next(0, item)
        ])
        XCTAssertEqual(addedObserver.events.count, 2)
    }

    func testCartViewModel() {
        let viewModel = CartViewModel(environment: environment)

        let cart: [CartItem] = ShopItem.testObjects.prefix(3).map { CartItem(item: $0) }
        let cartItem1 = cart[0]
        let cartItem2 = cart[1]
        let cartItem3 = cart[2]

        service.cart = cart
        let cartObserver = scheduler.createObserver([(CartItem, Bool)].self)
        let selectItemsObserver = scheduler.createObserver([CartItem].self)
        let purchaseEnableObserver = scheduler.createObserver(Bool.self)

        let loadObservable = scheduler.createHotObservable([
            .next(1, ())
        ])

        let selectItemObservable = scheduler.createHotObservable([
            .next(2, cartItem1),
            .next(3, cartItem2)
        ])

        let output = viewModel.transform(
            input: CartViewModel.Input(
                loadTrigger: loadObservable
                    .asDriver(onErrorJustReturn: ()),
                selectItem: selectItemObservable
                    .asDriver(onErrorJustReturn: cartItem1)
            )
        )

        output.items
            .subscribe(cartObserver)
            .disposed(by: disposeBag)

        output.selectedItems
            .subscribe(selectItemsObserver)
            .disposed(by: disposeBag)

        output.purchaseEnable
            .subscribe(purchaseEnableObserver)
            .disposed(by: disposeBag)

        scheduler.start()

        let cartResults = cartObserver.events.compactMap {
            $0.value.element?.map { $0.0 }
        }

        let cartSelectResults = cartObserver.events.compactMap {
            $0.value.element?.map { $0.1 }
        }

        XCTAssertEqual(cartResults, [[], cart, cart, cart])
        XCTAssertEqual(cartSelectResults, [
            [],
            [false, false, false],
            [true, false, false],
            [true, true, false],
        ])
        XCTAssertEqual(selectItemsObserver.events, [
            .next(0, []),
            .next(1, []),
            .next(2, [cartItem1]),
            .next(3, [cartItem1, cartItem2])
        ])
        XCTAssertEqual(purchaseEnableObserver.events, [
            .next(0, false),
            .next(2, true),
            .next(3, true),
        ])
    }

    func testConfirmOrderViewModel() {
        let items: [CartItem] = ShopItem.testObjects.prefix(3).map { CartItem(item: $0) }
        let viewModel = ConfirmOrderViewModel(environment: environment, items: items)

        let itemsObserver = scheduler.createObserver([CartItem].self)
        let orderCompleteObserver = scheduler.createObserver(Void.self)

        let makeOrderObservable = scheduler.createHotObservable([
            .next(1, ())
        ])
        let output = viewModel.transform(
            input: ConfirmOrderViewModel.Input(
                makeOrder: makeOrderObservable
                    .asDriver(onErrorJustReturn: ())
            )
        )

        output.items
            .subscribe(itemsObserver)
            .disposed(by: disposeBag)

        output.orderComplete
            .subscribe(orderCompleteObserver)
            .disposed(by: disposeBag)

        XCTAssertEqual(orderCompleteObserver.events.count, 0)
        scheduler.start()

        XCTAssertEqual(itemsObserver.events, [
            .next(0, items)
        ])
        XCTAssertEqual(orderCompleteObserver.events.count, 1)
    }

    func testHistoryOrderViewModel() {
        let viewModel = HistoryOrderViewModel(environment: environment)
        let orders: [HistoryOrder] = [
            HistoryOrder(items: ShopItem.testObjects.prefix(3).map { CartItem(item: $0) }),
            HistoryOrder(items: ShopItem.testObjects.prefix(1).map { CartItem(item: $0) }),
        ]
        service.historyOrders = orders

        let observer = scheduler.createObserver([HistoryOrder].self)
        let observable = scheduler.createHotObservable([
            .next(1, ())
        ])

        let output = viewModel.transform(
            input: HistoryOrderViewModel.Input(
                loadTrigger: observable
                    .asDriver(onErrorJustReturn: ())
            )
        )

        output.orders
            .subscribe(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(observer.events, [
            .next(0, []),
            .next(1, orders)
        ])
    }

}
