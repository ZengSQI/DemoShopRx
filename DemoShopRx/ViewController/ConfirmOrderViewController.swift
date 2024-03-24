//
//  ConfirmOrderViewController.swift
//  DemoShopRx
//
//  Created by Steven Zeng on 2024/3/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

protocol ConfirmOrderViewControllerDelegate: AnyObject {
    func confirmOrderComplete()
}

class ConfirmOrderViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderItemTableViewCell.self, forCellReuseIdentifier: "OrderItemTableViewCell")
        tableView.estimatedRowHeight = 104
        return tableView
    }()

    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    private lazy var makeOrderButton: UIButton = {
        let button = UIButton()
        button.configuration = .custom(color: .systemGreen)
        button.setTitle("提交訂單", for: .normal)
        return button
    }()

    private var viewModel: ConfirmOrderViewModel!
    private var disposeBag = DisposeBag()

    weak var delegate: ConfirmOrderViewControllerDelegate?

    convenience init(viewModel: ConfirmOrderViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        bindViewModel()
        title = "確認訂單"
    }

    private func setupSubview() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(totalPriceLabel)
        view.addSubview(makeOrderButton)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        makeOrderButton.snp.makeConstraints { make in
            make.top.equalTo(totalPriceLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
        }
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: ConfirmOrderViewModel.Input(
                makeOrder: makeOrderButton.rx.tap
                    .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                    .asDriver(onErrorJustReturn: ())
            )
        )

        output.items
            .bind(to: tableView.rx.items(cellIdentifier: "OrderItemTableViewCell", cellType: OrderItemTableViewCell.self)) { row, model, cell in
                cell.bind(item: model)
            }
            .disposed(by: disposeBag)

        output.totalPrice
            .map { "總金額: \($0.formatted())" }
            .bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)

        output.orderComplete
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.showOrderCompleteAlert()
            }
            .disposed(by: disposeBag)
    }

    private func showOrderCompleteAlert() {
        let alert = UIAlertController(title: "購買成功", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.delegate?.confirmOrderComplete()
        })
        present(alert, animated: true)
    }
}
