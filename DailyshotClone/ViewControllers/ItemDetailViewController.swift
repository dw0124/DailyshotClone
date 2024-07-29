//
//  ItemDetailViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/26/24.
//

import UIKit
import Foundation

import SnapKit

import RxSwift
import RxDataSources

class ItemDetailViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ItemDetailViewModel!
    
    var disposeBag = DisposeBag()
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    var toolbarStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension ItemDetailViewController {
    func bindViewModel() {
        let dataSource = RxTableViewSectionedReloadDataSource<DetailSectionModel>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                switch item {
                case .itemCell(let dailyshotItem):
                    let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailImageCell.identifier, for: indexPath) as! ItemDetailImageCell
                    
                    cell.configure(dailyshotItem)
                    
                    return cell
                case .storeCell:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailStoreCell.identifier, for: indexPath) as! ItemDetailStoreCell
                    
                    if let store = self?.viewModel.storeRelay.value {
                        cell.configure(store: store)
                    }
                    
                    cell.button.rx.tap
                        .subscribe(onNext: { _ in
                            UIView.performWithoutAnimation {
                                let currentOffset = tableView.contentOffset
                                
                                UIView.performWithoutAnimation {
                                    tableView.beginUpdates()
                                    tableView.endUpdates()
                                    
                                    tableView.setContentOffset(currentOffset, animated: true)
                                }
                            }
                        })
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                case .description(let dailyshotItem):
                    let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailDescriptionCell.identifier, for: indexPath) as! ItemDetailDescriptionCell
                    cell.configure(dailyshotItem)
                    return cell
                case .tastingNotes(let tastingNotes):
                    let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailTastingNotesCell.identifier, for: indexPath) as! ItemDetailTastingNotesCell
                    cell.configure(tastingNotes)
                    return cell
                case .information(let inform):
                    let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailInformationCell.identifier, for: indexPath) as! ItemDetailInformationCell
                    cell.configure(inform)
                    return cell
                }
            }, titleForHeaderInSection: { dataSource, index in
                return ""
            })
        
        viewModel.sectionModels
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        let _ = tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setup() {
        setupNavigationBar()
        setupToolbar()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        
        setupTableView()
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        
        view.addSubview(separatorView)
        view.addSubview(toolbarStackView)
        view.addSubview(tableView)
        
        toolbarStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(toolbarStackView.snp.top)
            $0.leading.trailing.equalTo(toolbarStackView)
            $0.height.equalTo(1) // 1pt height for the separator line
        }
        
        tableView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(toolbarStackView.snp.top)
        }
    }
    
    func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
        let homeButton = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: nil)
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: nil)
        
        backButton.tintColor = .black
        homeButton.tintColor = .black
        shareButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [shareButton, homeButton]
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        homeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    func setupTableView() {
        tableView.register(ItemDetailImageCell.self, forCellReuseIdentifier: ItemDetailImageCell.identifier)
        tableView.register(ItemDetailStoreCell.self, forCellReuseIdentifier: ItemDetailStoreCell.identifier)
        tableView.register(ItemDetailDescriptionCell.self, forCellReuseIdentifier: ItemDetailDescriptionCell.identifier)
        tableView.register(ItemDetailTastingNotesCell.self, forCellReuseIdentifier: ItemDetailTastingNotesCell.identifier)
        tableView.register(ItemDetailInformationCell.self, forCellReuseIdentifier: ItemDetailInformationCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        
        tableView.backgroundColor = .white
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }
    
    func setupToolbar() {
        let likeButton: UIButton = {
            let button = UIButton()
            
            // 버튼 상태에 따라 이미지 설정
            button.setImage(UIImage(named: "heart"), for: .normal)
            button.setImage(UIImage(named: "heart.fill"), for: .selected)
            
            // 타이틀 설정
            var attString = AttributedString("0")
            attString.font = .systemFont(ofSize: 10, weight: .regular)
            
            // UIButton.Configuration 설정
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = attString
            configuration.imagePadding = 1
            configuration.imagePlacement = .top

            configuration.baseBackgroundColor = .white
            button.configuration = configuration
            button.tintColor = .darkGray
            return button
        }()
        
        let presentButton = UIButton()
        presentButton.setImage(UIImage(systemName: "gift"), for: .normal)
        presentButton.setTitle("선물하기", for: .normal)
        presentButton.setTitleColor(.black, for: .normal)
        presentButton.layer.borderWidth = 2
        presentButton.layer.borderColor = UIColor.orange.cgColor
        presentButton.layer.cornerRadius = 10
        presentButton.tintColor = .orange
        presentButton.addPadding(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let pickupOrderButton = UIButton()
        pickupOrderButton.setImage(UIImage(systemName: "figure.walk"), for: .normal)
        pickupOrderButton.setTitle("방문픽업 주문하기", for: .normal)
        pickupOrderButton.setTitleColor(.black, for: .normal)
        pickupOrderButton.backgroundColor = .orange
        pickupOrderButton.setTitleColor(.white, for: .normal)
        pickupOrderButton.tintColor = .white
        pickupOrderButton.layer.cornerRadius = 10
        pickupOrderButton.addPadding(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        toolbarStackView = {
            let stackView = UIStackView(arrangedSubviews: [likeButton, presentButton, pickupOrderButton])
            stackView.backgroundColor = .white
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 12
            return stackView
        }()
        
        toolbarStackView.layer.addBorder([.top], color: .black, width: 1)
        toolbarStackView.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 0, right: 12)
        toolbarStackView.isLayoutMarginsRelativeArrangement = true
        
        likeButton.snp.makeConstraints {
            $0.width.equalTo(33).priority(.required)
        }
        
        presentButton.snp.makeConstraints {
            $0.width.equalTo(130).priority(.required)
        }
        
        likeButton.rx.tap
            .subscribe(onNext: { _ in
                likeButton.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        presentButton.rx.tap
            .subscribe(onNext: {
                
            })
            .disposed(by: disposeBag)
        
        pickupOrderButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let store = self.viewModel.storeRelay.value
                let item = self.viewModel.dailyshotItemRelay.value
                
                let viewModel = SelectStoreViewModel(store: store, dailyshotItem: item)
                var viewController = SelectStoreViewcontroller()
                viewController.bind(viewModel: viewModel)
                
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension ItemDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = viewModel.sectionModels.value[section]
        switch sectionModel.type {
        case .item:
            return 0
        case .store:
            return 3
        case .tastingNotes:
            return 6
        case .information:
            return 3
        case .description:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch section {
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundView = UIView()
            headerView.backgroundView?.backgroundColor = .systemGray5
        }
    }
}
