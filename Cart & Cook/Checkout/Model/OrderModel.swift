//
//  OrderModel.swift
//  Cart & Cook
//
//  Created by Development  on 30/05/2021.
//

import Foundation

// MARK: - OrderModel
struct OrderModel: Codable {
    let message: String?
    let orderID: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case orderID = "OrderID"
    }
}
