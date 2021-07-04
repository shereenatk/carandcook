//
//  SupplierPlaceOrderM.swift
//  Cart & Cook
//
//  Created by Development  on 29/06/2021.
//

import Foundation

struct SupplierPlaceOrderM: Codable {
    let message: String?
    let orderID: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case orderID = "OrderID"
    }
}
