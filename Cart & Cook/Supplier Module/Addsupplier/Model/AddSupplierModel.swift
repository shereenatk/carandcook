//
//  AddSupplierModel.swift
//  Cart & Cook
//
//  Created by Development  on 23/06/2021.
//

import Foundation

// MARK: - SAddProductM
import Foundation

// MARK: - CategoryListModel
struct AddSupplierModel: Codable {
    let message: String?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
    }
}
