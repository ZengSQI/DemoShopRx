//
//  ShopListViewController.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/22.
//

import UIKit
import RxSwift
import RxCocoa

class ShopListViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ShopListCollectionViewCell.self, forCellWithReuseIdentifier: "ShopListCollectionViewCell")
        return collectionView
    }()

    private lazy var layout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .flexible(16)
        group.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()

    private var viewModel: ShopListViewModel!
    private var disposeBag = DisposeBag()

    convenience init(viewModel: ShopListViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        bindViewModel()
        title = "商品列表"
    }

    private func setupSubview() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: ShopListViewModel.Input(load: .just(()))
        )

        output.list
            .bind(to: collectionView.rx.items(cellIdentifier: "ShopListCollectionViewCell", cellType: ShopListCollectionViewCell.self)) { index, model, cell in
                cell.bind(item: model)
            }
            .disposed(by: disposeBag)
    }
}

