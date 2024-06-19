//
//  ItemListViewController.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/19/24.
//

import Foundation
import UIKit

import RxSwift

class ItemListViewController: UIViewController, ViewModelBindableType {

    var viewModel: ItemListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    func bindViewModel() {
        
    }
    
    
}
