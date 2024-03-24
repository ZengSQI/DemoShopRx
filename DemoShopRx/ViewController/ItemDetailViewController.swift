//
//  ItemDetailViewController.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/23.
//

import RxCocoa
import RxSwift
import RxSwiftExt
import RxViewController
import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
    func itemDetailDidTapPurchase(item: ShopItem)
}

class ItemDetailViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    private lazy var createTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            descriptionLabel,
            priceLabel,
            createTimeLabel,
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.configuration = .custom(color: .systemYellow)
        button.setTitle("加入購物車", for: .normal)
        return button
    }()

    private lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.configuration = .custom(color: .systemGreen)
        button.setTitle("直接購買", for: .normal)
        return button
    }()

    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            addToCartButton,
            purchaseButton,
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()

    private var viewModel: ItemDetailViewModel!
    private var disposeBag = DisposeBag()

    weak var delegate: ItemDetailViewControllerDelegate?

    convenience init(viewModel: ItemDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        bindViewModel()
        title = "商品詳情"
    }

    private func setupSubview() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(contentStackView)
        scrollView.addSubview(buttonStack)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top).inset(16)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.width.equalTo(view).inset(16)
            make.height.equalTo(imageView.snp.width)
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(16)
        }

        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(32)
            make.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: ItemDetailViewModel.Input(
                addToCart: addToCartButton.rx.tap
                    .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                    .asDriver(onErrorJustReturn: ())
            )
        )

        output.item
            .withUnretained(self)
            .subscribe { owner, item in
                owner.bind(item: item)
            }
            .disposed(by: disposeBag)

        output.added
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.showAddedToCartAlert()
            }
            .disposed(by: disposeBag)

        purchaseButton.rx.tap
            .withLatestFrom(output.item)
            .withUnretained(self)
            .subscribe { owner, item in
                owner.delegate?.itemDetailDidTapPurchase(item: item)
            }
            .disposed(by: disposeBag)
    }

    private func bind(item: ShopItem) {
        imageView.image = UIImage(named: item.imageName)
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = "$ " + item.price.formatted()
        createTimeLabel.text = "上架時間: " + Date(timeIntervalSince1970: item.createdAt).formatted()
    }

    private func showAddedToCartAlert() {
        let alert = UIAlertController(title: "已加入購物車", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
