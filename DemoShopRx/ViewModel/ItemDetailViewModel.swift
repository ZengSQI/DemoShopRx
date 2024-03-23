//
//  ItemDetailViewModel.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/23.
//

import RxCocoa
import RxSwift

class ItemDetailViewModel: ViewModelType {
    struct Input {
        let addToCart: Driver<Void>
    }

    struct Output {
        let item: BehaviorRelay<ShopItem>
        let added: PublishRelay<Void>
    }

    private var environment: Environment
    private var item: ShopItem
    private var disposeBag = DisposeBag()

    init(environment: Environment, item: ShopItem) {
        self.environment = environment
        self.item = item
    }

    func transform(input: Input) -> Output {
        let itemRelay = BehaviorRelay<ShopItem>(value: item)
        let added = PublishRelay<Void>()

        input.addToCart
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.environment.service.addToCart(item: owner.item)
            }
            .map { _ in Void() }
            .bind(to: added)
            .disposed(by: disposeBag)

        return Output(
            item: itemRelay,
            added: added
        )
    }
}
