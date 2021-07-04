//
//  PaymemntSuccessModel.swift
//  Cart & Cook
//
//  Created by Development  on 27/06/2021.
//
import Foundation

// MARK: - PaymentSuccessModel
struct PaymentSuccessModel: Codable {
    let transactionID, amountPaid, decision, responseCode: String?
    let cardNumber, cardExpiry, cardType, cardTypeID: String?

    enum CodingKeys: String, CodingKey {
        case transactionID = "TransactionId"
        case amountPaid = "AmountPaid"
        case decision = "Decision"
        case responseCode = "ResponseCode"
        case cardNumber = "CardNumber"
        case cardExpiry = "CardExpiry"
        case cardType = "CardType"
        case cardTypeID = "CardTypeID"
    }
}
