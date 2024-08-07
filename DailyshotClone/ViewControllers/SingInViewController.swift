//
//  SingInViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/7/24.
//

import Foundation
import UIKit

import SnapKit

import RxSwift

class SignInViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: SignInViewModel!
    
    var disposeBag = DisposeBag()
    
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    let signInButton = UIButton()
    
    let findUserInfoButton = UIButton()
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
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 버튼 활성화 상태에 따라 색상 변경
        Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .subscribe(onNext: { [weak self] isEnabled in
                self?.signInButton.backgroundColor = isEnabled ? .systemOrange : .systemGray
            })
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let email = self?.emailTextField.text
                let password = self?.passwordTextField.text
                
                self?.viewModel.signInWithEmail(email: email, password: password)
            })
            .disposed(by: disposeBag)
    }
    
}
extension SignInViewController {
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
        
        // 로그인 버튼 설정
        signInButton.setTitle("로그인", for: .normal)
        signInButton.backgroundColor = .systemGray
        signInButton.layer.cornerRadius = 5
        signInButton.isUserInteractionEnabled = true
        
        // ID/PW 찾기 버튼 설정
        findUserInfoButton.setTitleSize(title: "아이디/비밀번호 찾기", size: 14, weight: .regular)
        findUserInfoButton.setTitleColor(.black, for: .normal)
        findUserInfoButton.backgroundColor = .clear
        findUserInfoButton.isUserInteractionEnabled = true
        
        // 회원가입 버튼 설정
        signUpButton.setTitleSize(title: "회원 가입", size: 14, weight: .regular)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.backgroundColor = .clear
        signUpButton.isUserInteractionEnabled = true
        
        let signInStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
            stackView.axis = .vertical
            stackView.spacing = 10
            return stackView
        }()
        
        let buttonStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [findUserInfoButton, signUpButton])
            stackView.axis = .horizontal
            stackView.distribution = .equalCentering
            stackView.spacing = 10
            return stackView
        }()
        
        let totalStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [signInStackView, buttonStackView])
            stackView.axis = .vertical
            stackView.spacing = 20
            return stackView
        }()
        
        signInStackView.setCustomSpacing(20, after: passwordTextField)
        
        view.addSubview(totalStackView)
        
        totalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        signInButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
