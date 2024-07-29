//
//  FilterView.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/15/24.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

class FilterView: UIView {
    
    var disposeBag = DisposeBag()
    
    var isFilter = false
    
    // 필터 옵션 목록
    var filterOptions: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: [])
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 10
        return stackView
    }()
    
    // 필터 추가 버튼
    let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.layer.cornerRadius = 20
        button.tintColor = .black
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(FilterOptionCell.self, forCellWithReuseIdentifier: FilterOptionCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.setTitle("초기화", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.addPadding(top: 0, leading: 10, bottom: 0, trailing: 0)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(collectionView)
        
        addSubview(resetButton)
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        resetButton.snp.makeConstraints {
            $0.centerY.equalTo(collectionView)
            $0.height.equalTo(collectionView)
            $0.trailing.equalTo(collectionView)
        }
        
        binding()
    }
    
    private func binding() {
        filterOptions
            .bind(to: collectionView.rx.items(cellIdentifier: FilterOptionCell.identifier, cellType: FilterOptionCell.self)) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        filterOptions
            .subscribe(onNext: { [weak self] options in
                guard let self = self else { return }
                if options.isEmpty || isFilter == false {
                    self.collectionView.isHidden = true
                    self.resetButton.isHidden = true
                    //self.filterStackView.isHidden = true
                } else {
                    self.collectionView.isHidden = false
                    self.resetButton.isHidden = false
                    //self.filterStackView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
}
// MARK: - FilterOptionCell
class FilterOptionCell: UICollectionViewCell {
    
    static let identifier = "FilterOptionCell"
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.backgroundColor = .systemGray6
        stackView.layer.cornerRadius = 5
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        contentView.addSubview(stackView)
        
        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(deleteButton)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.imageView?.snp.makeConstraints {
            $0.height.equalTo(12).priority(.required)
            $0.width.equalTo(12).priority(.required)
        }
    }
    
    func configure(with filterOption: String) {
        titleLabel.text = filterOption
    }
}
