//
//  FilterListViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

class FilterListViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: FilterListViewModel!
    var disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FilterListCell.self, forCellWithReuseIdentifier: FilterListCell.identifier)
        collectionView.register(FilterListHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FilterListHeaderCell.identifier)
        collectionView.register(C_SeparatorFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: C_SeparatorFooterView.identifier)
        return collectionView
    }()
    
    private var resetButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.setTitle("초기화", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.addPadding(top: 10, leading: 10, bottom: 10, trailing: 10)
        return button
    }()
    
    private var setFilterButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.setTitle("필터 적용하기", for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addPadding(top: 10, leading: 10, bottom: 10, trailing: 10)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
    }
    
    func bindViewModel() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<FilterListSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterListCell.identifier, for: indexPath) as! FilterListCell
                let filterType = dataSource.sectionModels[indexPath.section].type
                
                cell.configure(type: filterType, with: item)
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                if kind == UICollectionView.elementKindSectionHeader {
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterListHeaderCell.identifier, for: indexPath) as! FilterListHeaderCell
                    let section = dataSource.sectionModels[indexPath.section]
                    headerView.configure(with: section.header)
                    return headerView
                } else {
                    let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: C_SeparatorFooterView.identifier, for: indexPath) as! C_SeparatorFooterView
                    return footerView
                }
            }
        )
        
        viewModel.sectionModels
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 셀 선택
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let filterType = dataSource.sectionModels[indexPath.section].type.rawValue
                let option = dataSource.sectionModels[indexPath.section].items[indexPath.item]
                
                viewModel.selectOption(type: filterType, option: option)
            })
            .disposed(by: disposeBag)
        
        // 셀 선택 해제
        collectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let filterType = dataSource.sectionModels[indexPath.section].type.rawValue
                let option = dataSource.sectionModels[indexPath.section].items[indexPath.item]
                
                viewModel.selectOption(type: filterType, option: option)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.selectedOptions
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        // 리셋 버튼
        resetButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.resetOption()
            })
            .disposed(by: disposeBag)
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        let buttonStackView = UIStackView(arrangedSubviews: [resetButton, setFilterButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.distribution = .fillEqually
        buttonStackView.setContentHuggingPriority(.required, for: .vertical)
        buttonStackView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        view.addSubview(buttonStackView)
        view.addSubview(collectionView)
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-12)
        }
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: nil)
        backButton.tintColor = .black
        
        let soldoutButton: UIButton = {
            let button = UIButton()
            button.setTitle("품절포함", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.red, for: .selected)
            button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            return button
        }()
        
        let soldoutBarButton = UIBarButtonItem(customView: soldoutButton)
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = soldoutBarButton
        navigationItem.title = "필터"
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        soldoutButton.rx.tap
            .subscribe(onNext: { soldoutButton.isSelected.toggle() })
            .disposed(by: disposeBag)
    }
}

extension FilterListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0.5)
    }
}
