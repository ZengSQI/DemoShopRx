//
//  HistoryOrderSupplementaryView.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/24.
//

import UIKit

class HistoryOrderSupplementaryView: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        backgroundColor = .systemGray6
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.trailing.equalToSuperview().inset(16)
        }
    }

    func bind(title: String) {
        titleLabel.text = title
    }
}
