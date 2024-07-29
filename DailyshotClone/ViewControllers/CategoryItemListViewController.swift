//
//  CategoryItemListViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/15/24.
//

import UIKit
import Foundation

import RxSwift
import RxDataSources

class CategoryItemListViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: CategoryItemListViewModel!
    
    var disposeBag = DisposeBag()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    var filterView: FilterView = {
        let view = FilterView()
        return view
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        let itemW = UIScreen.main.bounds.width / 2 - 16
        let itemH = itemW * 1.8
        layout.itemSize = CGSize(width: itemW, height: itemH)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.backgroundView?.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SmallItemImageCell.self, forCellWithReuseIdentifier: SmallItemImageCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.addArrangedSubview(filterView)
        stackView.addArrangedSubview(collectionView)
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        filterView.snp.makeConstraints {
            $0.height.equalTo(32)
        }
    }
    
    func bindViewModel() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ItemListSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallItemImageCell.identifier, for: indexPath) as! SmallItemImageCell
                cell.configure(with: item)
                return cell
            }
        )
        
        viewModel.sectionModels
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(DailyshotItem.self)
            .subscribe(onNext: { dailyshotItem in
                let viewModel = ItemDetailViewModel(dailyshotItem: dailyshotItem)
                var viewController = ItemDetailViewController()
                
                viewController.bind(viewModel: viewModel)
                
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        filterView.filterButton.rx.tap
            .subscribe(onNext: {
                
                let viewModel = FilterListViewModel()
                var viewController = FilterListViewController()
                viewController.bind(viewModel: viewModel)
                
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .automatic  // 또는 .automatic, .overFullScreen 등 필요에 따라 변경
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension UIView {
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
       let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
       let mask = CAShapeLayer()
       mask.path = path.cgPath
       layer.mask = mask
   }
}
