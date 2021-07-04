//
//  MyOrderModel.swift
//  Cart & Cook
//
//  Created by Development  on 30/05/2021.
//


import Foundation

// MARK: - MyOrderModelElement
struct MyOrderModelElement: Codable {
    let orderID: Int?
    let customerName, deliveryAddress, deliveryCity, deliveryState: String?
    let deliveryCountry, deliveryPinCode, phoneNumber, orderStatus: String?
    let total: Double?
    let orderDate: String?
    let items: [Item]?
    let gpsCoordinates: String?
    let deliverySlotTime, paymentMethod, payment: String?
    let deliveredDate: String?
    let cancelledDate, vatNumber: String?
    let isOffline: Bool?

    enum CodingKeys: String, CodingKey {
        case orderID = "OrderID"
        case customerName = "CustomerName"
        case deliveryAddress = "DeliveryAddress"
        case deliveryCity = "DeliveryCity"
        case deliveryState = "DeliveryState"
        case deliveryCountry = "DeliveryCountry"
        case deliveryPinCode = "DeliveryPinCode"
        case phoneNumber = "PhoneNumber"
        case orderStatus = "OrderStatus"
        case total = "Total"
        case orderDate = "OrderDate"
        case items = "Items"
        case gpsCoordinates = "GPSCoordinates"
        case deliverySlotTime = "DeliverySlotTime"
        case paymentMethod = "PaymentMethod"
        case payment = "Payment"
        case deliveredDate = "DeliveredDate"
        case cancelledDate = "CancelledDate"
        case vatNumber = "VATNumber"
        case isOffline = "IsOffline"
    }
}

// MARK: - Item
struct Item: Codable {
    let itemID: Int?
    let name: String?
    let image: String?
    let weight, price: Double?
    let unit: String?
    let priceQuality: String?

    enum CodingKeys: String, CodingKey {
        case itemID = "ItemId"
        case name = "Name"
        case image = "Image"
        case weight = "Weight"
        case price = "Price"
        case unit = "Unit"
        case priceQuality = "PriceQuality"
    }
}
typealias MyOrderModel = [MyOrderModelElement]
