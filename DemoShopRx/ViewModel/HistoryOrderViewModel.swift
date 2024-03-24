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
        let loadTrigger: Driver<Void>
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
        let ordersRelay = BehaviorRelay<[HistoryOrder]>(value: [])

        input.loadTrigger
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.environment.service.getHistoryOrders()
            }
            .bind(to: ordersRelay)
            .disposed(by: disposeBag)

        return Output(orders: ordersRelay)
    }
}
