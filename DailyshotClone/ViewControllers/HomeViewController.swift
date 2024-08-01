//
//  HomeViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/7/24.
//

import UIKit
import Foundation

import SnapKit

import RxSwift
import RxCocoa
import RxDataSources
    
class HomeViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: HomeViewModel!
    
    var disposeBag = DisposeBag()
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        setupNavigtaion()
    }
}

extension HomeViewController {
    func bindViewModel() {

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch item {
                case .banner(let items):
                    let cell = tableView.dequeueReusableCell(withIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
                    cell.configure(items.first!.images)
                    return cell
                case .menu(let items):
                    let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
                    
                    cell.collectionView.rx.itemSelected
                        .subscribe(onNext: { [weak self] indexPath in
                            guard let self = self else { return }
                            
                            switch items[indexPath.row].viewControllerType {
                            case .category:
                                var viewController = CategoryViewController()
                                let viewModel = CategoryViewModel()
                                
                                viewController.hidesBottomBarWhenPushed = true
                                navigationController?.pushViewController(viewController, animated: true)
                            case .itemList:
                                break
                            }
                            
                        })
                        .disposed(by: cell.disposeBag)
                    
                    cell.configure(items)
                    return cell
                case .smallItem(let items):
                    return self.configureCell(tableView: tableView, indexPath: indexPath, items: items, cellType: SmallItemCell.self)
                case .mediumItem(items: let items):
                    return self.configureCell(tableView: tableView, indexPath: indexPath, items: items, cellType: MediumItemCell.self)
                case .largeItem(items: let items):
                    return self.configureCell(tableView: tableView, indexPath: indexPath, items: items, cellType: LargeItemCell.self)
                }
            }, titleForHeaderInSection: { dataSource, index in
                return ""
            }
        )
        
        viewModel.sectionModels
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // tableView의 높이 설정
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        tableView.register(BannerCell.self, forCellReuseIdentifier: BannerCell.identifier)
        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
        tableView.register(SmallItemCell.self, forCellReuseIdentifier: SmallItemCell.identifier)
        tableView.register(MediumItemCell.self, forCellReuseIdentifier: MediumItemCell.identifier)
        tableView.register(LargeItemCell.self, forCellReuseIdentifier: LargeItemCell.identifier)
        tableView.register(HomeItemHeaderCell.self, forHeaderFooterViewReuseIdentifier: HomeItemHeaderCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigtaion() {
        navigationController?.navigationBar.backgroundColor = .clear
        
        let addressButton = UIButton(type: .system)
        addressButton.setTitle("서울특별시 강서구", for: .normal)
        addressButton.titleLabel?.lineBreakMode = .byTruncatingTail
        addressButton.titleLabel?.numberOfLines = 1
        
        // UIBarButtonItem에 customView를 설정
        let barButtonItem = UIBarButtonItem(customView: addressButton)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: nil)
        
        addressButton.tintColor = .black
        searchButton.tintColor = .black
        cartButton.tintColor = .black
        
        barButtonItem.customView?.snp.makeConstraints {
            $0.width.equalTo(200)
        }
        
        addressButton.titleLabel?.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        searchButton.customView?.setContentCompressionResistancePriority(.required, for: .horizontal)
        cartButton.customView?.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        navigationItem.leftBarButtonItems = [barButtonItem, flexibleSpace]
        navigationItem.rightBarButtonItems = [cartButton, searchButton]
        
    }
    
    private func configureCell<T: HomeCellType>(tableView: UITableView, indexPath: IndexPath, items: [T.ItemType], cellType: T.Type) -> T {
        let cell = tableView.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
        
        cell.configure(items)
        
        cell.collectionView.rx.modelSelected(T.ItemType.self)
            .subscribe(onNext: { item in
                let dailyshotItem = item as! DailyshotItem
                
                let viewModel = ItemDetailViewModel(dailyshotItem: dailyshotItem)
                var viewController = ItemDetailViewController()
                
                viewController.bind(viewModel: viewModel)
                
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.sectionModels.value[indexPath.section]
        let item = section.items[indexPath.row]
        return item.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 1 ? 84 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeItemHeaderCell.identifier) as! HomeItemHeaderCell
        
        if let sectionHeader = viewModel.sectionModels.value[section].header {
            headerView.configure(with: sectionHeader)

            headerView.headerButton.rx.tap
                .subscribe { _ in
                    let viewModel = ItemListViewModel(self.viewModel.sectionModels.value[section])
                    var viewController = ItemListViewController()
                    viewController.bind(viewModel: viewModel)
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                .disposed(by: headerView.disposeBag)
        }
        
        return section > 1 ? headerView : nil 
    }
}
