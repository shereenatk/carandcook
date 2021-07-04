//
//  sAddProductM.swift
//  Cart & Cook
//
//  Created by Development  on 22/06/2021.
//

import Foundation
import UIKit
import Foundation

// MARK: - SAddProductMElement
struct SAddProductMElement: Codable {
    let productID: Int?
    let productName, unit: String?
    let price: Double?
    let weight: Double?
    let typeID: Int?
    let typeName, countryName: String?

    enum CodingKeys: String, CodingKey {
        case productID = "ProductID"
        case productName = "ProductName"
        case unit = "Unit"
        case price = "Price"
        case weight = "Weight"
        case typeID = "TypeId"
        case typeName = "TypeName"
        case countryName = "CountryName"
    }
}

typealias SAddProductM = [SAddProductMElement]

