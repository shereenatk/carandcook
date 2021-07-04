//
//  SOASuplierModel.swift
//  Cart & Cook
//
//  Created by Development  on 20/06/2021.
//

import Foundation

// MARK: - SOASupplierViewmodel
struct SOASupplierModel: Codable {
    let result: SOASupplierResult?
    let id: Int?
    let status: Int?
    let isCanceled, isCompleted: Bool?
    let creationOptions: Int?
    let isFaulted: Bool?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "Id"
        case status = "Status"
        case isCanceled = "IsCanceled"
        case isCompleted = "IsCompleted"
        case creationOptions = "CreationOptions"
        case isFaulted = "IsFaulted"
    }
}

// MARK: - Result
struct SOASupplierResult: Codable {
    let supplierExpenseSOA: [SupplierExpenseSOA]?
}

// MARK: - SupplierExpenseSOA
struct SupplierExpenseSOA: Codable {
    let deliveredDate, date, month, year: String?
    let orderID: Int?
    let supplierName: String?
    let subAmount: Double?
    let vatAmount, totalAmount: Double?

    enum CodingKeys: String, CodingKey {
        case deliveredDate = "DeliveredDate"
        case date = "Date"
        case month = "Month"
        case year = "Year"
        case orderID = "OrderId"
        case supplierName = "SupplierName"
        case subAmount = "SubAmount"
        case vatAmount = "VATAmount"
        case totalAmount = "TotalAmount"
    }
}
