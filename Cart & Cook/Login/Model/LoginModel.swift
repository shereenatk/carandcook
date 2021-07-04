//
//  LoginModel.swift
//  Cart & Cook
//
//  Created by Development  on 19/05/2021.
//
import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let customerID: Int?
    let restaurants: [Restaurant]?
    let firstName, lastName, emailAddress, phoneNumber: String?
    let isActive, isVerified, isIncorrect, isDummy: Bool?

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerId"
        case restaurants = "Restaurants"
        case firstName = "FirstName"
        case lastName = "LastName"
        case emailAddress = "EmailAddress"
        case phoneNumber = "PhoneNumber"
        case isActive = "IsActive"
        case isVerified = "IsVerified"
        case isIncorrect = "IsIncorrect"
        case isDummy = "IsDummy"
    }
}

// MARK: - Restaurant
struct Restaurant: Codable {
    let restaurantID: Int?
    let restaurantName, vatNumber, brand: String?
    let outlets: [Outlet]?

    enum CodingKeys: String, CodingKey {
        case restaurantID = "RestaurantId"
        case restaurantName = "RestaurantName"
        case vatNumber = "VATNumber"
        case brand = "Brand"
        case outlets = "Outlets"
    }
}

// MARK: - Outlet
struct Outlet: Codable {
    let outletLocationID: Int?
    let outletLocationName: String?

    enum CodingKeys: String, CodingKey {
        case outletLocationID = "OutletLocationId"
        case outletLocationName = "OutletLocationName"
    }
}
