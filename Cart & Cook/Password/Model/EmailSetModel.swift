//
//  EmailSetModel.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation

// MARK: - EmailSetModel
struct EmailSetModel: Codable {
    let customerID: Int?
    let message: String?
    let isValid: Bool?

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerId"
        case message = "Message"
        case isValid = "IsValid"
    }
}
