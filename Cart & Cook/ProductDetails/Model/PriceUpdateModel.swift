//
//  PriceUpdateModel.swift
//  Cart & Cook
//
//  Created by Development  on 23/05/2021.
//

import Foundation

// MARK: - PriceUpdateModelElement
struct PriceUpdateModelElement: Codable {
    let itemID: Int?
    let unit: String?
    let weight: Int?
    let priceUpdateModelDescription: String?
    let priceHighQuality, priceLowQuality: Double?
    let isPromotionItem: Bool?
    let promotionPrice: Double?

    enum CodingKeys: String, CodingKey {
        case itemID = "ItemID"
        case unit = "Unit"
        case weight = "Weight"
        case priceUpdateModelDescription = "Description"
        case priceHighQuality = "PriceHighQuality"
        case priceLowQuality = "PriceLowQuality"
        case isPromotionItem = "IsPromotionItem"
        case promotionPrice = "PromotionPrice"
    }
}


typealias PriceUpdateModel = [PriceUpdateModelElement]
