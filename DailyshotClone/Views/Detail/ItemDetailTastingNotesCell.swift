//
//  ItemDetailTastingNotesCell.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/8/24.
//
import UIKit
import Foundation

class ItemDetailTastingNotesCell: UITableViewCell {
    
    static let identifier = "ItemDetailTastingNotesCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Tasting Notes"
        return label
    }()
    
    let aroma: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Aroma"
        return label
    }()
    
    let taste: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Taste"
        return label
    }()
    
    let finish: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Finish"
        return label
    }()
    
    let aromaK: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "향"
        label.textColor = .systemGray
        return label
    }()
    
    let tasteK: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "맛"
        label.textColor = .systemGray
        return label
    }()
    
    let finishK: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "여운"
        label.textColor = .systemGray
        return label
    }()
    
    
    let aromaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Aroma"
        return label
    }()
    
    let tasteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Taste"
        return label
    }()
    
    let finishLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Finish"
        return label
    }()
    
    private lazy var aromaStackView: UIStackView = {
        let containerView = UIStackView(arrangedSubviews: [aroma, aromaK])
        containerView.axis = .vertical
        containerView.alignment = .top
        containerView.distribution = .fill
        containerView.spacing = 4
        
        let stackView = UIStackView(arrangedSubviews: [containerView, aromaLabel])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var tasteStackView: UIStackView = {
        let containerView = UIStackView(arrangedSubviews: [taste, tasteK])
        containerView.axis = .vertical
        containerView.alignment = .top
        containerView.distribution = .fill
        containerView.spacing = 4
        
        let stackView = UIStackView(arrangedSubviews: [containerView, tasteLabel])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var finishStackView: UIStackView = {
        let containerView = UIStackView(arrangedSubviews: [finish, finishK])
        containerView.axis = .vertical
        containerView.alignment = .top
        containerView.distribution = .fill
        containerView.spacing = 4
        
        let stackView = UIStackView(arrangedSubviews: [containerView, finishLabel])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, aromaStackView, tasteStackView, finishStackView])
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // setup UI + Layout
    private func setupCell() {
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        aroma.snp.makeConstraints {
            $0.width.equalTo(64)
        }
        taste.snp.makeConstraints {
            $0.width.equalTo(aroma)
        }
        finish.snp.makeConstraints {
            $0.width.equalTo(aroma)
        }
    }
    
    func configure(_ tastingNotes: TastingNotes) {
        aromaLabel.text = tastingNotes.aroma
        tasteLabel.text = tastingNotes.taste
        finishLabel.text = tastingNotes.finish
    }
}
