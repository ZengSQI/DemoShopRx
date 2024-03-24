//
//  CartItemTableViewCell.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/24.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "circle"))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubview() {
        contentView.addSubview(checkImageView)
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)

        checkImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        itemImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(checkImageView.snp.trailing).offset(16)
            make.width.height.equalTo(80)
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

    func bind(item: CartItem, isSelected: Bool) {
        checkImageView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        checkImageView.tintColor = isSelected ? .systemGreen : .systemGray
        itemImageView.image = UIImage(named: item.item.imageName)
        nameLabel.text = item.item.name
        priceLabel.text = "$ " + item.item.price.formatted()
    }
}
