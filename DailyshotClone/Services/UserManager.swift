//
//  UserManager.swift
//  DailyshotClone
//
//  Created by 김두원 on 8/8/24.
//

import Foundation

import FirebaseAuth
import FirebaseDatabase

import RxSwift
import RxRelay

class UserManager {
    
    static let shared = UserManager()
    
    var currentUser: User?
    
    private init() {
        setUser()
    }
    
    private func setUser() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let email = user.email ?? ""
            let name = user.displayName ?? ""
            let phoneNumber = user.phoneNumber ?? ""
            
            let userManagerUser = User(userId: userId, email: email, name: name, phoneNumber: phoneNumber, wishList: [])
            
            self.currentUser = userManagerUser
        }
    }
}
