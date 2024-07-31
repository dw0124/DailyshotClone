//
//  MainTabBarViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 7/31/24.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .black

        // 홈
        var homeVC = HomeViewController()
        let homeViewModel = HomeViewModel()
        homeVC.bind(viewModel: homeViewModel)
        let homeTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        homeVC.tabBarItem = homeTabBarItem
        let homeNC = UINavigationController(rootViewController: homeVC)
        
        // 마이 페이지
        var myPageVC = MyPageViewController()
        let myPageTabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        myPageVC.tabBarItem = myPageTabBarItem
        
        self.viewControllers = [homeNC, myPageVC]
    }
}
