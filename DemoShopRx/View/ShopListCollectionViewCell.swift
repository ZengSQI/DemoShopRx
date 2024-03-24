//
//  ShopListCollectionViewCell.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/23.
//

import SnapKit
import UIKit

class ShopListCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubview() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(16)
        }
    }

    func bind(item: ShopItem) {
        imageView.image = UIImage(named: item.imageName)
        nameLabel.text = item.name
        priceLabel.text = "$ " + item.price.formatted()
    }
}
