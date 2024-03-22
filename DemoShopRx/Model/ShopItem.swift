//
//  ShopItem.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/22.
//

import Foundation

struct ShopItem: Hashable, Equatable {
    let id: UUID = .init()
    let name: String
    let description: String
    let price: Int
    let createdAt: TimeInterval
    let imageName: String
}

extension ShopItem {
    static var testObjects: [ShopItem] {
        return [
            ShopItem(
                name: "豬肉滿福堡加蛋",
                description: "香嫩柔軟的太陽蛋，絕配香煎豬肉片，還有熱騰騰融化的切達吉事，最後蓋上軟中帶勁的滿福麵包！吃滿福保好運、上班上學一切順利！",
                price: 10000,
                createdAt: Date().timeIntervalSince1970,
                imageName: "sausage-mcmuffin-with-egg"
            ),
            ShopItem(
                name: "豬肉滿福堡",
                description: "早餐推薦！美國小麥製的滿福麵包，比你的彈簧床還Q彈！搭配香煎豬肉片與切達吉事，簡單美味。吃滿福，保好運，吃豬肉滿福堡，堡豬事福氣滿出來！",
                price: 10000,
                createdAt: Date().timeIntervalSince1970,
                imageName: "sausage-mcmuffin"
            ),
            ShopItem(
                name: "無敵豬肉滿福堡加蛋",
                description: "吃無敵豬肉滿福堡給你無敵活力！兩層香煎豬肉片，與獨家氣蒸太陽蛋和切達吉事，最後蓋上軟中帶勁的滿福麵包，吃滿福，保好運，今天你最無敵！",
                price: 100,
                createdAt: Date().timeIntervalSince1970,
                imageName: "mega-mcmuffin"
            ),
            ShopItem(
                name: "滿福堡",
                description: "早餐推薦你最經典的英式滿福!特選洗選蛋搭配櫸木煙燻火腿片，最後放上一片熱呼呼融化的切達吉事，這樣開啟一天真好!吃滿福，保好運，活力滿格，好運也滿格喔！",
                price: 100,
                createdAt: Date().timeIntervalSince1970,
                imageName: "egg-mcmuffin"
            ),
            ShopItem(
                name: "青蔬滿福堡",
                description: "讓一抹綠，鮮活你一天的開始！翠綠的新鮮萵苣，與柔嫩太陽蛋，伴佐火腿來提味，最後再用切達吉事點綴，層次豐富。吃滿福，保好運，一天這樣開始真的好幸福！",
                price: 100,
                createdAt: Date().timeIntervalSince1970,
                imageName: "muffin-with-vegetables"
            ),
        ]
    }
}
