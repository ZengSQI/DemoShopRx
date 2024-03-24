//
//  ShopListViewController.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

protocol ShopListViewControllerDelegate: AnyObject {
    func shopListDidTapItem(item: ShopItem)
    func shopListDidTapCart()
    func shopListDidTapHistory()
}

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

    private lazy var cartButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: nil, action: nil)
        return item
    }()

    private lazy var historyButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "clock.arrow.circlepath"), style: .plain, target: nil, action: nil)
        return item
    }()

    private var viewModel: ShopListViewModel!
    private var disposeBag = DisposeBag()

    weak var delegate: ShopListViewControllerDelegate?

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
        navigationItem.rightBarButtonItems = [cartButton, historyButton]
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: ShopListViewModel.Input(
                load: rx.viewWillAppear
                    .map { _ in Void() }
                    .asDriver(onErrorJustReturn: ())
            )
        )

        output.list
            .bind(to: collectionView.rx.items(cellIdentifier: "ShopListCollectionViewCell", cellType: ShopListCollectionViewCell.self)) { index, model, cell in
                cell.bind(item: model)
            }
            .disposed(by: disposeBag)

        collectionView.rx
            .modelSelected(ShopItem.self)
            .withUnretained(self)
            .subscribe { owner, item in
                owner.delegate?.shopListDidTapItem(item: item)
            }
            .disposed(by: disposeBag)

        cartButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.delegate?.shopListDidTapCart()
            }
            .disposed(by: disposeBag)

        historyButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.delegate?.shopListDidTapHistory()
            }
            .disposed(by: disposeBag)
    }
}

