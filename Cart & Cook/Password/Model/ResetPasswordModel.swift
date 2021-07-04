//
//  ResetPasswordModel.swift
//  Cart & Cook
//
//  Created by Development  on 31/05/2021.
//

import Foundation

// MARK: - ResetPasswordModel
struct ResetPasswordModel: Codable {
    let customerID: Int?
    let isVerified, isActive, isIncorrect: Bool?

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerId"
        case isVerified = "IsVerified"
        case isActive = "IsActive"
        case isIncorrect = "IsIncorrect"
    }
}
