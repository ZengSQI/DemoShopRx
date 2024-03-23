//
//  CartViewController.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

protocol CartViewControllerDelegate: AnyObject {
    func cartDidTapPurchase(items: [CartItem])
}

class CartViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: "CartItemTableViewCell")
        tableView.estimatedRowHeight = 112
        tableView.contentInset.bottom = 92
        return tableView
    }()

    private lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.configuration = .custom(color: .systemGreen)
        button.setTitle("結算", for: .normal)
        return button
    }()

    private var viewModel: CartViewModel!
    private var disposeBag = DisposeBag()

    weak var delegate: CartViewControllerDelegate?

    convenience init(viewModel: CartViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        bindViewModel()
        title = "購物車"
    }

    private func setupSubview() {
        view.addSubview(tableView)
        view.addSubview(purchaseButton)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        purchaseButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
        }
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: CartViewModel.Input(
                load: rx.viewWillAppear
                    .map { _ in Void() }
                    .asDriver(onErrorJustReturn: ()),
                selectItem: tableView.rx
                    .modelSelected((CartItem, Bool).self)
                    .map { $0.0 }
                    .asDriver(onErrorDriveWith: .empty())
            )
        )

        output.items
            .bind(to: tableView.rx.items(cellIdentifier: "CartItemTableViewCell", cellType: CartItemTableViewCell.self)) { row, model, cell in
                cell.bind(item: model.0, isSelected: model.1)
            }
            .disposed(by: disposeBag)

        output.purchaseEnable
            .bind(to: purchaseButton.rx.isEnabled)
            .disposed(by: disposeBag)

        purchaseButton.rx.tap
            .withLatestFrom(output.selectedItems)
            .withUnretained(self)
            .subscribe { owner, items in
                owner.delegate?.cartDidTapPurchase(items: items)
            }
            .disposed(by: disposeBag)
    }
}
