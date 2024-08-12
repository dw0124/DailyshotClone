//
//  CartViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/1/24.
//

import Foundation
import UIKit

import RxSwift

class CartViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: CartViewModel!
    
    var disposeBag = DisposeBag()
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigtaion()
    }
}

extension CartViewController {
    func bindViewModel() {
        viewModel.displayedCartRelay
            .bind(to: tableView.rx.items(cellIdentifier: CartCell.identifier, cellType: CartCell.self)) { index, cart, cell in
                
                let cart = self.viewModel.cartRelay.value[index]
                
                let isSelected = cart.isSelected
                let item = cart.item
                let store = cart.store
                let itemCount = cart.count
                
                self.viewModel.cartRelay
                    .subscribe(onNext: { cartItems in
                        guard index < cartItems.count else { return }
                        let isSelected = cartItems[index].isSelected
                        cell.selectButton.isSelected = isSelected
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.selectButton.rx.tap
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        let isSelected = self.viewModel.selectCart(index: index)
                        cell.selectButton.isSelected = isSelected
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.stepper.value
                    .distinctUntilChanged()
                    .subscribe(onNext: { [weak self] count in
                        guard let self = self else { return }
                        if count == self.viewModel.cartRelay.value[index].count { return }
                        self.viewModel.changeCount(index: index, count: count)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.deleteButton.rx.tap
                    .subscribe(onNext: { [weak self] _ in
                        self?.viewModel.removeFromCart(index: index)
                        
                        self?.tableView.reloadData()
                    })
                    .disposed(by: cell.disposeBag)
                
                if let store = store, let item = item {
                    cell.configure(isSelected: isSelected, store: store, item: item, itemCount: itemCount)
                }
            }
            .disposed(by: disposeBag)
        
        let _ = tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        let purchaseButton = UIButton()
        purchaseButton.setImage(UIImage(systemName: "figure.walk"), for: .normal)
        purchaseButton.setTitle("선택상품 구매하기", for: .normal)
        purchaseButton.setTitleColor(.black, for: .normal)
        purchaseButton.backgroundColor = .orange
        purchaseButton.setTitleColor(.white, for: .normal)
        purchaseButton.tintColor = .white
        purchaseButton.layer.cornerRadius = 10
        purchaseButton.addPadding(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        tableView.register(CartHeaderView.self, forHeaderFooterViewReuseIdentifier: CartHeaderView.identifier)
        tableView.register(CartFooterView.self, forHeaderFooterViewReuseIdentifier: CartFooterView.identifier)
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 10, left: 0.0, bottom: .zero, right: 0.0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        
        let toolbarStackView = {
            let stackView = UIStackView(arrangedSubviews: [purchaseButton])
            stackView.backgroundColor = .white
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
            return stackView
        }()
        
        toolbarStackView.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 0, right: 12)
        toolbarStackView.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(toolbarStackView)
        view.addSubview(separatorView)
        view.addSubview(tableView)
        
        toolbarStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(toolbarStackView.snp.top)
            $0.width.equalToSuperview()
            $0.height.equalTo(0.3)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(toolbarStackView.snp.top)
        }
    }
    
    private func setupNavigtaion() {
        navigationController?.navigationBar.backgroundColor = .clear
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = "장바구니"
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView Delegate / Header + Footer
extension CartViewController: UITableViewDelegate {
    
    // MARK: TableView Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartHeaderView.identifier) as! CartHeaderView
        
        viewModel.cartRelay
            .subscribe(onNext: { items in
                let isAllSelected = items.allSatisfy { $0.isSelected }
                headerView.selectButton.isSelected = isAllSelected
            })
            .disposed(by: headerView.disposeBag)
        
        headerView.selectButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                headerView.selectButton.isSelected.toggle()
                let isSelected = headerView.selectButton.isSelected
                self?.viewModel.selectAll(isSelected)
            })
            .disposed(by: headerView.disposeBag)
        
        headerView.deleteButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.removeSelectedItems()
                tableView.reloadData()
            })
            .disposed(by: headerView.disposeBag)
        
        return headerView
    }
    
    // MARK: TableView Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartFooterView.identifier) as! CartFooterView
        
        viewModel.cartRelay
            .map { cart in
                cart.reduce(0) {
                    $0 + ($1.isSelected ? ($1.item?.finalPrice ?? 0) * $1.count : 0)
                }
            }
            .distinctUntilChanged()
            .subscribe(onNext: { totalSelectedPrice in
                footer.configure(price: totalSelectedPrice)
            })
            .disposed(by: footer.disposeBag)
        
        return footer
    }
}
