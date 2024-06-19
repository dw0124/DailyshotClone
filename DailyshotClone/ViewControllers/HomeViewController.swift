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

extension NumberFormatter {
    static func setDecimal(_ num: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let price = num
        let result = numberFormatter.string(for: price)!
        
        return result
    }
}
    
class HomeViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: HomeViewModel!
    
    var disposeBag = DisposeBag()
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        //bind()

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
                    cell.configure(items)
                    return cell
                case .smallItem(let items):
                    let cell = tableView.dequeueReusableCell(withIdentifier: SmallItemCell.identifier, for: indexPath) as! SmallItemCell
                    cell.configure(items)
                    return cell
                case .mediumItem(items: let items):
                    let cell = tableView.dequeueReusableCell(withIdentifier: MediumItemCell.identifier, for: indexPath) as! MediumItemCell
                    cell.configure(items)
                    return cell
                case .largeItem(items: let items):
                    let cell = tableView.dequeueReusableCell(withIdentifier: LargeItemCell.identifier, for: indexPath) as! LargeItemCell
                    cell.configure(items)
                    return cell
                }
            }, titleForHeaderInSection: { dataSource, index in
                return " "
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
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.sectionModels.value[indexPath.section]
        let item = section.items[indexPath.row]
        return item.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 1 ? 70 : 0
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
