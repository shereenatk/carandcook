//
//  ProductListModel.swift
//  Cart & Cook
//
//  Created by Development  on 23/05/2021.
//

import Foundation

// MARK: - PoductListModelElement
struct PoductListModelElement: Codable {
    let itemID: Int?
    let item, itemCode, itemType: String?
    let image, thumbnailImage : String?
    let unit: String?
    let weight: Double?
    let price: Double?
    let poductListModelDescription, country: String?
    let storageRequirements, packagingDisclaimer, itemCount, shelfLife: String?
    let priceHighQuality, priceLowQuality: Double?
    let isPromotionItem: Bool?
    let promotionPrice: Double?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case itemID = "ItemID"
        case item = "Item"
        case itemCode = "ItemCode"
        case itemType = "ItemType"
        case image = "Image"
        case unit = "Unit"
        case weight = "Weight"
        case price = "Price"
        case poductListModelDescription = "Description"
        case country = "Country"
        case storageRequirements = "StorageRequirements"
        case packagingDisclaimer = "PackagingDisclaimer"
        case itemCount = "ItemCount"
        case shelfLife = "ShelfLife"
        case priceHighQuality = "PriceHighQuality"
        case priceLowQuality = "PriceLowQuality"
        case isPromotionItem = "IsPromotionItem"
        case promotionPrice = "PromotionPrice"
        case status = "Status"
        case thumbnailImage = "ThumbnailImage"
    }
}
typealias PoductListModel = [PoductListModelElement]
