//
//  ShopListViewController.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/22.
//

import UIKit
import RxSwift
import RxCocoa

class ShopListViewController: UIViewController {

    private var viewModel: ShopListViewModel!
    private var disposeBag = DisposeBag()

    convenience init(viewModel: ShopListViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    func bindViewModel() {
        let output = viewModel.transform(
            input: ShopListViewModel.Input(load: .just(()))
        )

        output.list
            .debug()
            .bind { items in
                print(items)
            }
            .disposed(by: disposeBag)
    }
}

