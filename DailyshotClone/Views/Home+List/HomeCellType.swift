//
//  HomeCellType.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/26/24.
//

import UIKit
import Foundation

import RxSwift

protocol HomeCellType {
    associatedtype ItemType
    static var identifier: String { get }
    var collectionView: UICollectionView { get }
    var disposeBag: DisposeBag { get }
    func configure(_ items: [ItemType])
}
