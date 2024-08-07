//
//  SignUpViewModel.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/7/24.
//

import Foundation

import FirebaseAuth
import FirebaseDatabase

class SignUpViewModel {
    
    init() {
        
    }
    
    /// 회원가입을 위한 메소드 Firebase Auth와 Realtime DB에 유저 정보 저장
    func signUpWithEmail(email: String?, password: String?) {
        if let email = email, let password = password {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print(error)
                    return
                }
                
                if let user = authResult?.user {
                    // 사용자 고유 ID
                    let userID = user.uid
                    
                    // Realtime Database에 사용자 정보 저장
                    let userRef = Database.database().reference().child("users").child(userID)
                    
                    // 사용자 정보를 딕셔너리 형태로 저장
                    let userInfo = ["email": email]
                    
                    // 사용자 정보를 Realtime Database에 저장
                    userRef.setValue(userInfo) { error, _ in
                        if let error = error {
                            print("Error saving user data: \(error)")
                        } else {
                            print("User data saved successfully!")
                        }
                    }
                }
            }
        }
    }
    
}
