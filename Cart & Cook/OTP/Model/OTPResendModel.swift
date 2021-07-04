//
//  OTPResendModel.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//


import Foundation

// MARK: - ResendOTPModel
struct OTPResendModel: Codable {
    let customerID: Int?

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerId"
    }
}
