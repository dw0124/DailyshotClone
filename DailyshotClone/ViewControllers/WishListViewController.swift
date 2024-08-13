//
//  WishListViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/6/24.
//

import Foundation
import UIKit

import RxSwift

class WishListViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: WishListViewModel!
    
    var disposeBag = DisposeBag()
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigtaion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        disposeBag = DisposeBag()
        
        bindViewModel()
        
        viewModel.updateWishList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    func bindViewModel() {
        
        viewModel.itemsRelay
            .bind(to: tableView.rx.items) { (tableView, row, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: WishListCell.identifier) as! WishListCell
                cell.configure(item: item)
                
                cell.deleteButton.rx.tap
                    .flatMap { [weak self] _ -> Observable<Bool> in
                        guard let self = self else { return Observable.just(false) }
                        let itemId = self.viewModel.itemsRelay.value[row].productId
                        return WishListManager.shared.removeFromWishList(with: itemId)
                    }
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        var items = self.viewModel.itemsRelay.value
                        items.remove(at: row)
                        self.viewModel.itemsRelay.accept(items)
                        
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(DailyshotItem.self)
            .subscribe(onNext: { [weak self] item in
                var viewController = ItemDetailViewController()
                let viewModel = ItemDetailViewModel(dailyshotItem: item)
                viewController.bind(viewModel: viewModel)
                
                viewController.hidesBottomBarWhenPushed = true
                
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        tableView.register(WishListCell.self, forCellReuseIdentifier: WishListCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 10, left: 0.0, bottom: .zero, right: 0.0)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupNavigtaion() {
        navigationController?.navigationBar.backgroundColor = .clear
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.black
        label.text = "위시리스트"
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: nil)
        
        searchButton.tintColor = .black
        cartButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        navigationItem.rightBarButtonItems = [cartButton, searchButton]
        
        cartButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                var viewController = CartViewController()
                let viewModel = CartViewModel()
                viewController.bind(viewModel: viewModel)
                
                viewController.hidesBottomBarWhenPushed = true
                
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
