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
        let load: Driver<Void>
        let makeOrder: Driver<Void>
    }

    struct Output {
        let items: PublishRelay<[CartItem]>
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
        let itemsRelay = PublishRelay<[CartItem]>()
        let totalPriceRelay = PublishRelay<Int>()
        let orderCompleteRelay = PublishRelay<Void>()

        input.load
            .asObservable()
            .withUnretained(self)
            .map { owner, _ in owner.items }
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)

        itemsRelay
            .map { $0.reduce(0) { $0 + $1.item.price } }
            .bind(to: totalPriceRelay)
            .disposed(by: disposeBag)

        input.makeOrder
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, _ in
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
