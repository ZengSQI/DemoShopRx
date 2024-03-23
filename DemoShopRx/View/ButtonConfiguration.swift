//
//  ButtonConfiguration.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/23.
//

import UIKit

extension UIButton.Configuration {
    static func custom(color: UIColor) -> Self {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .medium
        config.baseBackgroundColor = color
        config.baseForegroundColor = .white
        return config
    }
}
