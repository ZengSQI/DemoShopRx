//
//  ShopListViewModel.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/23.
//

import RxCocoa
import RxSwift

class ShopListViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        let items: BehaviorRelay<[ShopItem]>
    }

    private var environment: Environment
    private var disposeBag = DisposeBag()

    init(environment: Environment) {
        self.environment = environment
    }

    func transform(input: Input) -> Output {
        let itemsRelay = BehaviorRelay<[ShopItem]>(value: [])

        input.loadTrigger
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.environment.service.getList()
            }
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)

        return Output(items: itemsRelay)
    }
}
