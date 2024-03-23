//
//  CartViewModel.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/24.
//

import RxCocoa
import RxSwift

class CartViewModel: ViewModelType {
    struct Input {
        let load: Driver<Void>
        let selectItem: Driver<CartItem>
    }

    struct Output {
        let items: BehaviorRelay<[(CartItem, Bool)]>
        let purchaseEnable: BehaviorRelay<Bool>
    }

    private var environment: Environment
    private var disposeBag = DisposeBag()
    private var selectedItems: Set<CartItem> = []

    init(environment: Environment) {
        self.environment = environment
    }

    func transform(input: Input) -> Output {
        let cardItemsRelay = BehaviorRelay<[CartItem]>(value: [])
        let selectedItemsRelay = BehaviorRelay<Set<CartItem>>(value: selectedItems)
        let itemsRelay = BehaviorRelay<[(CartItem, Bool)]>(value: [])
        let purchaseEnableRelay = BehaviorRelay<Bool>(value: false)

        input.load
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.environment.service.getCart()
            }
            .bind(to: cardItemsRelay)
            .disposed(by: disposeBag)

        input.selectItem
            .asObservable()
            .withUnretained(self)
            .map { owner, item in
                owner.selectedItems.formSymmetricDifference([item])
                return owner.selectedItems
            }
            .bind(to: selectedItemsRelay)
            .disposed(by: disposeBag)

        Observable.combineLatest(cardItemsRelay, selectedItemsRelay)
            .map { items, seletedItems in
                items.compactMap { ($0, seletedItems.contains($0)) }
            }
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)

        selectedItemsRelay
            .map { !$0.isEmpty }
            .bind(to: purchaseEnableRelay)
            .disposed(by: disposeBag)

        return Output(
            items: itemsRelay,
            purchaseEnable: purchaseEnableRelay
        )
    }
}
