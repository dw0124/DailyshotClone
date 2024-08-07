//
//  SignUpViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/7/24.
//

import Foundation
import UIKit

import SnapKit

import RxSwift

class SignUpViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: SignUpViewModel!
    
    var disposeBag = DisposeBag()
    
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    let signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func bindViewModel() {
        // 두 텍스트 필드의 입력값이 모두 존재하는지 확인
        let emailValid = emailTextField.rx.text.orEmpty.map { !$0.isEmpty }
        let passwordValid = passwordTextField.rx.text.orEmpty.map { !$0.isEmpty }
        
        Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 버튼 활성화 상태에 따라 색상 변경
        Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .subscribe(onNext: { [weak self] isEnabled in
                self?.signUpButton.backgroundColor = isEnabled ? .systemOrange : .systemGray
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let email = self?.emailTextField.text
                let password = self?.passwordTextField.text
                
                self?.viewModel.signUpWithEmail(email: email, password: password)
            })
            .disposed(by: disposeBag)
    }
    
}
extension SignUpViewController {
    private func setup() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // 배경 색상 설정
        view.backgroundColor = .white
        
        // 이메일 텍스트 필드 설정
        emailTextField.placeholder = "이메일"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.clearButtonMode = .whileEditing
        
        // 비밀번호 텍스트 필드 설정
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.clearButtonMode = .whileEditing
        
        // 회원가입 버튼 설정
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = .systemGray
        signUpButton.layer.cornerRadius = 5
        signUpButton.isUserInteractionEnabled = true
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signUpButton])
            stackView.axis = .vertical
            stackView.spacing = 10
            return stackView
        }()
        
        stackView.setCustomSpacing(20, after: passwordTextField)
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
