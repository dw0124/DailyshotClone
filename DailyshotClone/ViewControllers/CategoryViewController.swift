//
//  CategoryViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/12/24.
//

import UIKit
import Foundation

import RxSwift

class CategoryViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var currentPageIndex = 0
    
    // 상단 탭바로 사용하기 위한 collectionView
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        view.backgroundColor = .clear
        
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    var data = ["전체", "위스키", "와인", "맥주", "전통주", "기타"]
    
    var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var dataViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        // UI + Layout
        setupUI()
        
        // CollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // PageViewController
        setPageVC()
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let vc = dataViewControllers.first {
            pageViewController.setViewControllers([vc], direction: .forward, animated: true)
        }
    }

    func setupNavigationBar() {
        navigationItem.title = "카테고리"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: nil)
        
        backButton.tintColor = .black
        searchButton.tintColor = .black
        cartButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [cartButton, searchButton]
        
        backButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - PageViewController
extension CategoryViewController {
    func setPageVC() {
        data.forEach {
            var viewController = CategoryItemListViewController()
            let viewModel = CategoryItemListViewModel(urlStr: "api//\($0)")
            viewController.bind(viewModel: viewModel)
            
            dataViewControllers.append(viewController)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)

        collectionView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    
    private func updateSelectedCell(at index: Int) {
        // 이전 선택된 셀 상태를 회색으로 설정
        let previousIndexPath = IndexPath(item: currentPageIndex, section: 0)
        if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CategoryCell {
            previousCell.label.textColor = .lightGray
        }
        
        // 현재 선택된 셀 상태를 검정색으로 설정
        let currentIndexPath = IndexPath(item: index, section: 0)
        if let currentCell = collectionView.cellForItem(at: currentIndexPath) as? CategoryCell {
            currentCell.label.textColor = .black
        }
        
        // currentPageIndex 업데이트
        currentPageIndex = index
    }
}

// MARK: - CollectionView DataSource
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        
        cell.configure(with: data[indexPath.item])
        
        if indexPath.item == 0 {
            cell.label.textColor = .black
        }
        
        return cell
    }
}

// MARK: - CollectionView Delegate FlowLayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CategoryCell.fittingSize(availableHeight: 48, name: data[indexPath.item])
        }
}

// MARK: - CollectionView Delegate
extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let direction: UIPageViewController.NavigationDirection = currentPageIndex < indexPath.item ? .forward : .reverse
        updateSelectedCell(at: indexPath.item)
        
        pageViewController.setViewControllers([dataViewControllers[indexPath.item]], direction: direction, animated: true)
    }
}

// MARK: - PageViewController DataSource
extension CategoryViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        
        return dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        
        return dataViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first {
            if let index = dataViewControllers.firstIndex(of: currentViewController) {
                updateSelectedCell(at: index)
            }
        }
    }
}
