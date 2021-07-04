//
//  OTPValidationModel.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation

// MARK: - OTPValidationModel
struct OTPValidationModel: Codable {
    let customerID: Int?
    let message: String?
    let isOTPvalid: Bool?

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerId"
        case message = "Message"
        case isOTPvalid = "IsOTPvalid"
    }
}
