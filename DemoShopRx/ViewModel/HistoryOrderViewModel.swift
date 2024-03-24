//
//  HistoryOrderViewModel.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/24.
//

import RxCocoa
import RxSwift

class HistoryOrderViewModel: ViewModelType {
    struct Input {
        let load: Driver<Void>
    }

    struct Output {
        let orders: BehaviorRelay<[HistoryOrder]>
    }

    private var environment: Environment
    private var disposeBag = DisposeBag()

    init(environment: Environment) {
        self.environment = environment
    }

    func transform(input: Input) -> Output {
        let orders = BehaviorRelay<[HistoryOrder]>(value: [])

        input.load
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.environment.service.getHistoryOrders()
            }
            .bind(to: orders)
            .disposed(by: disposeBag)

        return Output(orders: orders)
    }
}
