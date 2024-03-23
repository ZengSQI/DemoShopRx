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
        let load: Driver<Void>
    }

    struct Output {
        let list: BehaviorRelay<[ShopItem]>
    }

    private var environment: Environment
    private var disposeBag = DisposeBag()

    init(environment: Environment) {
        self.environment = environment
    }

    func transform(input: Input) -> Output {
        let list = BehaviorRelay<[ShopItem]>(value: [])

        input.load
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.environment.service.getList()
            }
            .bind(to: list)
            .disposed(by: disposeBag)

        return Output(list: list)
    }
}
