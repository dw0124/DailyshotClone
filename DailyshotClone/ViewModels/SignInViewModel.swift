//
//  SignInViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/7/24.
//

import Foundation

import FirebaseAuth

class SignInViewModel {
    /// 로그인 메소드 - 로그인 성공시 화면 전환
    func signInWithEmail(email: String?, password: String?) {
        if let email = email, let password = password {
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
                if let error = error as? AuthErrorCode {
                    switch error.code {
                    case .invalidEmail, .wrongPassword:
                        print("이메일 또는 비밀번호가 일치하지 않습니다.")
                    case .userNotFound:
                        print("등록되지 않은 이메일입니다.")
                    default:
                        print("이메일을 확인 해주세요.")
                    }
                    return
                }
                
                if auth != nil {
                    print("로그인 성공")
                    
                    let mainTabBarViewController = MainTabBarViewController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(mainTabBarViewController, animated: false)
                }
            }
        }
    }
}
