//
//  SOACCModel.swift
//  Cart & Cook
//
//  Created by Development  on 20/06/2021.
//


import Foundation

// MARK: - SOACCViewmodel
struct SOACCModel: Codable {
    let result: [SOACCResult]?
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
struct SOACCResult: Codable {
    let deliveredDate, date, month, year: String?
    let orderID: Int?
    let paymentMethod, resultDescription: String?
    let amount: Double?
    let total: Double?

    enum CodingKeys: String, CodingKey {
        case deliveredDate = "DeliveredDate"
        case date = "Date"
        case month = "Month"
        case year = "Year"
        case orderID = "OrderId"
        case paymentMethod = "PaymentMethod"
        case resultDescription = "Description"
        case amount = "Amount"
        case total = "Total"
    }
}

