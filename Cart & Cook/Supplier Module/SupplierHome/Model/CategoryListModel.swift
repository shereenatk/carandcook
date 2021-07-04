//
//  CategoryListModel.swift
//  Cart & Cook
//
//  Created by Development  on 23/06/2021.
//

import Foundation

// MARK: - CategoryListModelElement
struct CategoryListModelElement: Codable {
    let typeID: Int?
    let type, typeCode: String?

    enum CodingKeys: String, CodingKey {
        case typeID = "TypeId"
        case type = "Type"
        case typeCode = "TypeCode"
    }
}

typealias CategoryListModel = [CategoryListModelElement]
