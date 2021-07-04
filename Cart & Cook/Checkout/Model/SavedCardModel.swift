//
//  SavedCardModel.swift
//  Cart & Cook
//
//  Created by Development  on 24/06/2021.
//

import Foundation

// MARK: - SavedCardsModelElement
struct SavedCardsModelElement: Codable {
    let cardID, customerID: Int?
    let paymentTokenID, cardNumber, cardExpiry, cardType: String?
    let cardTypeID: String?

    enum CodingKeys: String, CodingKey {
        case cardID = "CardId"
        case customerID = "CustomerID"
        case paymentTokenID = "PaymentTokenID"
        case cardNumber = "CardNumber"
        case cardExpiry = "CardExpiry"
        case cardType = "CardType"
        case cardTypeID = "CardTypeID"
    }
}

typealias SavedCardsModel = [SavedCardsModelElement]
