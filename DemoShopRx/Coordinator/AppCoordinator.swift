//
//  AppCoordinator.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/23.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []

    var navigationController: UINavigationController

    private var environment: Environment

    init(navigationController: UINavigationController, environment: Environment) {
        self.navigationController = navigationController
        self.environment = environment
    }

    func start() {
        let viewModel = ShopListViewModel(environment: environment)
        let viewController = ShopListViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
    }

    func toDetail(item: ShopItem) {
        let viewModel = ItemDetailViewModel(environment: environment, item: item)
        let viewController = ItemDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func toCart() {
        let viewModel = CartViewModel(environment: environment)
        let viewController = CartViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: ShopListViewControllerDelegate {
    func shopListDidTapItem(item: ShopItem) {
        toDetail(item: item)
    }

    func shopListDidTapCart() {
        toCart()
    }
}
