//
//  CustomStepper.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/11/24.
//

import UIKit
import SnapKit

import RxRelay
import RxSwift

class CustomStepper: UIControl{
    var disposeBag = DisposeBag()
    
    var leftBtn: UIButton!
    var rightBtn: UIButton!
    var centerLbl: UILabel!
    
    var value = BehaviorRelay(value: 1)
    
    // for storyboard
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        mySetup()
    }
    
    // for non-storyboard
    override init(frame: CGRect) {
        super.init(frame: frame)
        mySetup()
        binding()
    }
    
    // for basis initializer
    init(){
        super.init(frame: CGRect.zero)
        mySetup()
        binding()
    }
    
    // CGRect변화시 호출되는 메소드 (프로퍼티의 CGRect정보를 여기에 기입해도 가능)
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func mySetup() {
        leftBtn = UIButton()
        rightBtn = UIButton()
        centerLbl = UILabel()
        
        leftBtn.tag = -1
        leftBtn.setImage(UIImage(systemName: "minus"), for: .normal)
        leftBtn.isEnabled = false
        leftBtn.tintColor = .systemGray4
        
        rightBtn.tag = 1
        rightBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        rightBtn.tintColor = .black
        
        centerLbl.text = String(value.value)
        centerLbl.font = .systemFont(ofSize: 16)
        centerLbl.textColor = .black
        centerLbl.textAlignment = .center
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [leftBtn, centerLbl, rightBtn])
            stackView.axis = .horizontal
            stackView.spacing = 4
            stackView.distribution = .fillEqually
            return stackView
        }()
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func binding() {
        Observable.merge(
            leftBtn.rx.tap.map { self.leftBtn },
            rightBtn.rx.tap.map { self.rightBtn }
        )
        .subscribe(onNext: { [weak self] btn in
            self?.valueChange(btn)
        })
        .disposed(by: disposeBag)
        
        value
            .map { "\($0)" }
            .bind(to: centerLbl.rx.text)
            .disposed(by: disposeBag)
        
        value
            .subscribe(onNext: { [weak self] _ in
                self?.updateButtonStates()
            })
            .disposed(by: disposeBag)
    }
    
    private func valueChange(_ sender: UIButton) {
        let newValue = value.value + sender.tag
        self.value.accept(newValue)
        
        leftBtn.isEnabled = value.value == 1 ? false : true
        leftBtn.tintColor = leftBtn.isEnabled ? .black : .systemGray4
        
        rightBtn.isEnabled = value.value == 99 ? false : true
        rightBtn.tintColor = rightBtn.isEnabled ? .black : .systemGray4
    }
    
    private func updateButtonStates() {
        let currentValue = value.value
        
        leftBtn.isEnabled = currentValue == 1 ? false : true
        leftBtn.tintColor = leftBtn.isEnabled ? .black : .systemGray4
        
        rightBtn.isEnabled = currentValue == 99 ? false : true
        rightBtn.tintColor = rightBtn.isEnabled ? .black : .systemGray4
    }
}
