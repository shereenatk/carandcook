//
//  OverViewModel.swift
//  Cart & Cook
//
//  Created by Development  on 16/06/2021.
//

import Foundation


// MARK: - OverViewmodel
struct OverViewmodel: Codable {
    let result: Result?
    let id: Int?
    let exception: JSONNull?
    let status: Int?
    let isCanceled, isCompleted: Bool?
    let creationOptions: Int?
    let asyncState: JSONNull?
    let isFaulted: Bool?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "Id"
        case exception = "Exception"
        case status = "Status"
        case isCanceled = "IsCanceled"
        case isCompleted = "IsCompleted"
        case creationOptions = "CreationOptions"
        case asyncState = "AsyncState"
        case isFaulted = "IsFaulted"
    }
}

// MARK: - Result
struct Result: Codable {
    let expense: Expense?
    let expenseType: [ExpenseType]?
    let expenseProduct: [ExpenseProduct]?
    let chartData: [ChartDatum]?
}

// MARK: - ChartDatum
struct ChartDatum: Codable {
    let xValue: String?
    let yValue, ccValue: Double?
    let supplierValue: Double?

    enum CodingKeys: String, CodingKey {
        case xValue = "XValue"
        case yValue
        case ccValue = "cc_Value"
        case supplierValue = "supplier_Value"
    }
}

// MARK: - Expense
struct Expense: Codable {
    let orders, items: Int?
    let expense: JSONNull?
    let ccExpense: Double?
    let supplierExpense: Double?
    let totalExpense: Double?

    enum CodingKeys: String, CodingKey {
        case orders, items, expense
        case ccExpense = "cc_expense"
        case supplierExpense = "supplier_expense"
        case totalExpense = "total_expense"
    }
}

// MARK: - ExpenseProduct
struct ExpenseProduct: Codable {
    let productName: String?
    let prdctTotal: Int?
    let amount, percentage: Double?

    enum CodingKeys: String, CodingKey {
        case productName = "ProductName"
        case prdctTotal = "PrdctTotal"
        case amount = "Amount"
        case percentage = "Percentage"
    }
}

// MARK: - ExpenseType
struct ExpenseType: Codable {
    let type: String?
    let typeTotal: Int?
    let amount, percentage: Double?

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case typeTotal = "TypeTotal"
        case amount = "Amount"
        case percentage = "Percentage"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
