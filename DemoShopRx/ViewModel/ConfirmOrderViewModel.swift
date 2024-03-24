//
//  ConfirmOrderViewModel.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/24.
//

import RxCocoa
import RxSwift

class ConfirmOrderViewModel: ViewModelType {
    struct Input {
        let makeOrder: Driver<Void>
    }

    struct Output {
        let items: BehaviorRelay<[CartItem]>
        let totalPrice: PublishRelay<Int>
        let orderComplete: PublishRelay<Void>
    }

    private var environment: Environment
    private var disposeBag = DisposeBag()
    private var items: [CartItem] = []

    init(environment: Environment, items: [CartItem]) {
        self.environment = environment
        self.items = items

    }

    func transform(input: Input) -> Output {
        let itemsRelay = BehaviorRelay<[CartItem]>(value: items)
        let totalPriceRelay = PublishRelay<Int>()
        let orderCompleteRelay = PublishRelay<Void>()

        itemsRelay
            .map { $0.reduce(0) { $0 + $1.item.price } }
            .bind(to: totalPriceRelay)
            .disposed(by: disposeBag)

        input.makeOrder
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.environment.service.makeOrder(items: owner.items)
            }
            .map { _ in Void() }
            .bind(to: orderCompleteRelay)
            .disposed(by: disposeBag)

        return Output(
            items: itemsRelay,
            totalPrice: totalPriceRelay,
            orderComplete: orderCompleteRelay
        )
    }
}
