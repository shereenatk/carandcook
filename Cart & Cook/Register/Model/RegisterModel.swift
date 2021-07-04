//
//  RegisterModel.swift
//  Cart & Cook
//
//  Created by Development  on 19/05/2021.
//

import Foundation

// MARK: - RegisterModel
struct RegisterModel: Codable {
    let success: Bool?
    let message: String?
    let customerID: Int?

    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case message = "Message"
        case customerID = "CustomerId"
    }
}
