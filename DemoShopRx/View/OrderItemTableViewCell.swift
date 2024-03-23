//
//  OrderItemTableViewCell.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/24.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubview()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubview() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)

        itemImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(72)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    func bind(item: CartItem) {
        itemImageView.image = UIImage(named: item.item.imageName)
        nameLabel.text = item.item.name
        priceLabel.text = "$ " + item.item.price.formatted()
    }
}
