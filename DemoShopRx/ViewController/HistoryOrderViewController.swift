//
//  HistoryOrderViewController.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/24.
//

import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import UIKit

class HistoryOrderViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HistoryOrderCollectionViewCell.self, forCellWithReuseIdentifier: "HistoryOrderCollectionViewCell")
        collectionView.register(HistoryOrderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HistoryOrderSupplementaryViewHeader")
        collectionView.register(HistoryOrderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HistoryOrderSupplementaryViewFooter")
        return collectionView
    }()

    private lazy var layout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(160),
            heightDimension: .absolute(160)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topTrailing),
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottomTrailing),
        ]
        let layout = UICollectionViewCompositionalLayout(section: section)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        return layout
    }()

    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<HistoryOrder> = {
        let dataSource = RxCollectionViewSectionedReloadDataSource<HistoryOrder> { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryOrderCollectionViewCell", for: indexPath) as! HistoryOrderCollectionViewCell
            cell.bind(item: item.item)
            return cell
        }
        dataSource.configureSupplementaryView = { dataSource, collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HistoryOrderSupplementaryViewHeader", for: indexPath) as! HistoryOrderSupplementaryView

                section.bind(title: "訂單編號 \(dataSource[indexPath.section].id.uuidString.prefix(8))")

                return section
            } else if kind == UICollectionView.elementKindSectionFooter {
                let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HistoryOrderSupplementaryViewFooter", for: indexPath) as! HistoryOrderSupplementaryView

                section.bind(title: "總金額: \(dataSource[indexPath.section].items.reduce(0) { $0 + $1.item.price })")

                return section
            } else {
                return UICollectionReusableView()
            }
        }
        return dataSource
    }()

    private var viewModel: HistoryOrderViewModel!
    private var disposeBag = DisposeBag()

    convenience init(viewModel: HistoryOrderViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        bindViewModel()
        title = "歷史訂單"
    }

    private func setupSubview() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: HistoryOrderViewModel.Input(
                loadTrigger: rx.viewWillAppear
                    .map { _ in () }
                    .asDriver(onErrorJustReturn: ())
            )
        )

        output.orders
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
