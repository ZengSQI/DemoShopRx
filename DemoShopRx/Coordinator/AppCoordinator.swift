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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = ViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
}
