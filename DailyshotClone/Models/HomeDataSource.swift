//
//  HomeDataSource.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/19/24.
//

import Foundation
import RxDataSources

// 아이템 모델 정의
struct BannerItem {
    let images: [UIImage]
}

struct MenuButtonItem {
    let name: String
    let buttonImage: UIImage
}

// 섹션 모델 정의
enum SectionItem {
    case banner(items: [BannerItem])
    case menu(items: [MenuButtonItem])
    case smallItem(items: [DailyshotItem])
    case mediumItem(items: [DailyshotItem])
    case largeItem(items: [DailyshotItem])
    
    // 섹션 아이템에 따른 높이 계산
    var height: CGFloat {
        switch self {
        case .banner:
            return 200
        case .menu:
            return UIScreen.main.bounds.width * 0.5
        case .smallItem:
            return UIScreen.main.bounds.width * 0.85
        case .mediumItem:
            return UIScreen.main.bounds.width * 0.75
        case .largeItem:
            return UIScreen.main.bounds.width * 1.0
        }
    }
}

struct Header {
    var title: String
    var subTitle: String
}

struct SectionModel {
    var header: Header?
    var items: [SectionItem]
}

extension SectionModel: SectionModelType {
    typealias Item = SectionItem

    init(original: SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
