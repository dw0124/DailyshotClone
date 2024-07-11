//
//  DetailDataSource.swift
//  DailyshotClone
//
//  Created by 김두원 on 6/26/24.
//

import Foundation

import RxDataSources

enum DetailSectionType {
    case item
    case store
    case description
    case tastingNotes
    case information
}

enum DetailSectionItem {
    case itemCell(DailyshotItem)
    case storeCell
    case description(DailyshotItem)
    case tastingNotes(TastingNotes)
    case information(Information)
}

struct DetailSectionModel {
    var type: DetailSectionType
    var items: [DetailSectionItem]
}

extension DetailSectionModel: SectionModelType {
    typealias Item = DetailSectionItem

    init(original: DetailSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
