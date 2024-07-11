//
//  ItemListViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/19/24.
//

import Foundation
import UIKit

import SnapKit

import RxSwift
import RxDataSources

class ItemListViewController: UIViewController, ViewModelBindableType {
    
    var disposeBag = DisposeBag()
    
    var viewModel: ItemListViewModel!
    
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
        collectionView.register(ItemListHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ItemListHeaderCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    func bindViewModel() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ItemListSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallItemImageCell.identifier, for: indexPath) as! SmallItemImageCell
                cell.configure(with: item)
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                if kind == UICollectionView.elementKindSectionHeader {
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ItemListHeaderCell.identifier, for: indexPath) as! ItemListHeaderCell
                    let section = dataSource.sectionModels[indexPath.section]
                    if let header = section.header {
                        headerView.configure(with: header)
                    }
                    return headerView
                }
                return UICollectionReusableView()
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
        
        let _ = collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}
