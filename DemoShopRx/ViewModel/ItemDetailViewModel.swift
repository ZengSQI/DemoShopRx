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
        let load: Driver<Void>
        let addToCart: Driver<Void>
    }

    struct Output {
        let item: PublishRelay<ShopItem>
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
        let itemRelay = PublishRelay<ShopItem>()
        let added = PublishRelay<Void>()

        input.load
            .asObservable()
            .withUnretained(self)
            .map { owner, _ in owner.item }
            .bind(to: itemRelay)
            .disposed(by: disposeBag)

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
