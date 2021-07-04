// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let supplierListmodel = try? newJSONDecoder().decode(SupplierListmodel.self, from: jsonData)

import Foundation

// MARK: - SupplierListmodelElement
struct SupplierListmodelElement: Codable {
    let supplierID: Int?
    let supplierName, supplierCode, email, emirate: String?
    let vatNumber: Int?
    let phoneNumber, address, logo, telephone: String?
    let notes: String?
    let paymentTerm: String?
    let supplyCategory: String?
    let trnLicenseNo: String?
    let trnLicenseFile: String?
    let otherDocuments: String?
    let restaurantID: Int?
    let restaurantName: String?

    enum CodingKeys: String, CodingKey {
        case supplierID = "SupplierID"
        case supplierName = "SupplierName"
        case supplierCode = "SupplierCode"
        case email = "Email"
        case emirate = "Emirate"
        case vatNumber = "VATNumber"
        case phoneNumber = "PhoneNumber"
        case address = "Address"
        case logo = "Logo"
        case telephone = "Telephone"
        case notes = "Notes"
        case paymentTerm = "PaymentTerm"
        case supplyCategory = "SupplyCategory"
        case trnLicenseNo = "TRNLicenseNo"
        case trnLicenseFile = "TRNLicenseFile"
        case otherDocuments = "OtherDocuments"
        case restaurantID = "RestaurantId"
        case restaurantName = "RestaurantName"
    }
}


typealias SupplierListmodel = [SupplierListmodelElement]
