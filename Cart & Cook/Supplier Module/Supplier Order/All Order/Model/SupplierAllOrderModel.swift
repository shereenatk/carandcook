//
//  SupplierAllOrderModel.swift
//  Cart & Cook
//
//  Created by Development  on 23/06/2021.
//

import Foundation

// MARK: - SupplierAllOrderModel
struct SupplierAllOrderModel: Codable {
    let totalOrder: Int?
    let orders: [SupplierAllOrder]?

    enum CodingKeys: String, CodingKey {
        case totalOrder = "TotalOrder"
        case orders = "Orders"
    }
}

// MARK: - Order
struct SupplierAllOrder: Codable {
    let orderID, resturantID, supplierID: Int?
    let customerName, supplierName: String?
    let excludedVatAmount: Double?
    let vatAmount, includedVatAmount: Double?
    let orderDate: String?
    let statusID: Int?
    let orderStatus, invoicePath, paymentReceiptPath, deliveryNotePath: String?
    let items: [SupplierAllItem]?

    enum CodingKeys: String, CodingKey {
        case orderID = "OrderID"
        case resturantID = "ResturantID"
        case supplierID = "SupplierID"
        case customerName = "CustomerName"
        case supplierName = "SupplierName"
        case excludedVatAmount = "ExcludedVatAmount"
        case vatAmount = "VatAmount"
        case includedVatAmount = "IncludedVatAmount"
        case orderDate = "OrderDate"
        case statusID = "StatusId"
        case orderStatus = "OrderStatus"
        case invoicePath = "InvoicePath"
        case deliveryNotePath = "DeliveryNotePath"
        case items = "Items"
        case paymentReceiptPath = "PaymentReceiptPath"
    }
}

// MARK: - Item
struct SupplierAllItem: Codable {
    let productName: String?
    let itemID : Int?
    let unit: String?
    let price, weight : Double?

    enum CodingKeys: String, CodingKey {
        case productName = "ProductName"
        case itemID = "ItemId"
        case weight = "Weight"
        case price = "Price"
        case unit = "Unit"
    }
}



