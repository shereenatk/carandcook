//
//  PageRouter.swift
//  Fixperts
//
//  Created by Apple on 2/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

enum PageRouter: URLRequestConvertible {
   
    case register([String: Any])
    case otpValidate([String: Any])
    case otpResent([String: Any])
    case setPassword([String: Any])
    case resetPassword([String: Any])
    case login([String: Any])
    case getObject([String: Any])
    case productList
    case getTimeSlot
    case placeOrder([String: Any])
    case forgotPassword([String: Any])
    case confirmsuplierOrder([String: Any])
    case supplierPlaceOrder([String: Any])
    case getMyOrder([String: Any])
    case sentFeedBack([String: Any])
    case overView([String: Any])
    case soaCC([String: Any])
    case soaSupplier([String: Any])
    case supplierList([String: Any])
    case getProductList([String: Any])
    case mapProducts([String: Any])
    case updateSupplier([String: Any])
    case getSupplierOrderList([String: Any])
    case priceUpdate
    case getSavedCards([String: Any])
    case getCategory
    case getOutstandingAmount([String: Any])
    
    var method: HTTPMethod {
        switch self {
        case
            .otpValidate,
            .otpResent,
            .setPassword,
            .sentFeedBack,
            .updateSupplier,
            .resetPassword,
            .placeOrder,
            .forgotPassword,
            .confirmsuplierOrder,
            .supplierPlaceOrder,
            .mapProducts,
            .register:
            return .post
        case    .productList,
                .getTimeSlot,
                .getObject,
                .getMyOrder,
                .overView,
                .soaCC,
                .soaSupplier,
                .getProductList,
                .getCategory,
                .getSupplierOrderList,
                .getSavedCards,
                .priceUpdate,
                .supplierList,
                .getOutstandingAmount,
            .login:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let encoding: ParameterEncoding = {
            switch self {
            case
                .otpValidate,
                .otpResent,
                .setPassword,
                .productList,
                .getCategory,
                .getTimeSlot,
                .sentFeedBack,
                .updateSupplier,
                .placeOrder,
                .forgotPassword,
                .confirmsuplierOrder,
                .supplierPlaceOrder,
                .resetPassword,
                .mapProducts,
                .priceUpdate,
               .register:
                return JSONEncoding.default
            case
                .getObject,
                .overView,
                .getSavedCards,
                .soaCC,
                .soaSupplier,
                .supplierList,
                .getProductList,
                .getSupplierOrderList,
                .getMyOrder,
                .getOutstandingAmount,
                .login:
                return URLEncoding.default
                
            }
        }()
        let params: ([String: Any]?) = {
                   switch self {
                   case
                    .otpValidate(let params),
                    .otpResent(let params),
                    .setPassword(let params),
                    .login(let params),
                    .getObject(let params),
                    .placeOrder(let params),
                    .forgotPassword(let params),
                    .confirmsuplierOrder(let params),
                    .supplierPlaceOrder(let params),
                    .getMyOrder(let params),
                    .resetPassword(let params),
                    .sentFeedBack(let params),
                    .updateSupplier(let params),
                    .overView(let params),
                    .soaCC(let params),
                    .supplierList(let params),
                    .soaSupplier(let params),
                    .getProductList(let params),
                    .mapProducts(let params),
                    .getSupplierOrderList(let params),
                    .getOutstandingAmount(let params),
                    .getSavedCards(let params),
                    .register(let params):
                  
                       return params
                case
                    .getTimeSlot,
                    .getCategory,
                    .priceUpdate,
                    .productList:
                    return nil
                   }
        }()
               
        
        let headers: HTTPHeaders = {
            switch self {
            case
                .otpValidate,
                .otpResent,
                .setPassword,
                .login,
                .resetPassword,
                .productList,
                .getObject,
                .getTimeSlot,
                .placeOrder,
                .getMyOrder,
                .sentFeedBack,
                .overView,
                .soaCC,
                .supplierList,
                .updateSupplier,
                .soaSupplier,
                .getProductList,
                .mapProducts,
                .getCategory,
                .getSupplierOrderList,
                .supplierPlaceOrder,
                .getSavedCards,
                .confirmsuplierOrder,
                .priceUpdate,
                .forgotPassword,
                .getOutstandingAmount,
                .register:
                return AppConstants.getApiHeaders()
            }
        }()
        
        let url: URL? = {
            let relativePath: String?
            
            switch self {
            case .register:
                relativePath = "Customer/Register"
            case .otpValidate:
                relativePath = "Customer/Validate"
            case .otpResent:
                relativePath = "Customer/ResendOTP"
            case .setPassword:
                relativePath = "Customer/Credentials"
            case .login:
                relativePath = "Customer/Login"
            case .productList:
                relativePath = "Product/GetProductList"
            case .getObject:
                relativePath = "Product/GetObject"
            case .getTimeSlot:
                relativePath = "common/GetDeliverySlot"
            case .placeOrder:
                relativePath = "Order/PlaceOrder"
            case .getMyOrder:
                relativePath = "Order/OrderDetail"
            case .resetPassword:
                relativePath = "Customer/ResetPassword"
            case .sentFeedBack:
                relativePath = "Order/Feedback"
            case .overView:
                relativePath = "Dashboard/GetDashboardDetail"
            case .soaCC:
                relativePath = "Dashboard/GetCCSOAReport"
            case .soaSupplier:
                relativePath = "Dashboard/GetSupplierSOA"
            case .supplierList:
                relativePath = "Supplier/GetSupplierListByRestaurantId"
            case .getProductList:
                relativePath = "Supplier/GetProductList"
            case .mapProducts:
                relativePath = "Supplier/MapProductSupplier"
            case .getCategory:
                relativePath = "Product/Categories"
            case .updateSupplier:
                relativePath = "Supplier/AddOrEditSupplier"
            case .getSupplierOrderList:
                relativePath = "Supplier/GetAllOrderList"
            case .getSavedCards:
                relativePath = "customer/GetCustomerPaymentCardList"
            case .supplierPlaceOrder:
                relativePath = "Supplier/PlaceOrder"
            case .confirmsuplierOrder:
                relativePath = "Supplier/SupplierConfirmOrder"
            case .priceUpdate:
                relativePath = "Product/GetProductPriceUpdate"
            case .forgotPassword:
                relativePath = "Customer/ForgotPassword"
            case .getOutstandingAmount:
                relativePath = "Order/Outstanding"
            }
            
            var url = URL(string: AppConstants.getBaseUrl())
            
            if let relativePath = relativePath {
                url = url?.appendingPathComponent(relativePath)
            }
//         print(url)
            return url
        }()
        
        guard let formedURL = url else {
            throw URLError.urlMalformatted
        }
        var urlRequest = URLRequest(url: formedURL)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        return try encoding.encode(urlRequest, with: params)
    }
}



