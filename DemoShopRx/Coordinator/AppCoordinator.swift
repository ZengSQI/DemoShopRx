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
        navigationController.pushViewController(viewController, animated: false)
    }
}
