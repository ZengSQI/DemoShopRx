//
//  Environment.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/23.
//

import Foundation

final class Environment {
    private(set) var service: Service

    init(service: Service) {
        self.service = service
    }
}
