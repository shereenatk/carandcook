//
//  Global.swift
//  Site
//
//  Created by MAC on 24/01/2021.
//

import Foundation
import Foundation
import UIKit
import Kingfisher
let RESTAURANTNAME = "rname"
let IS_FIRST_TIME = "isfirsttime"
let IS_LOGIN = "islogin"
let ADDRESSID = "addressId"
let USER_NAME = "user_name"
let USERID = "user_id"
let ISACTIVATEDACCOUNT = "activeAccount"
let CARTCOUNT = "cart_count"
let SUPPLIERCARTCOUNT = "supplier_id"
let SUPPLIERID = "supplier_cart_count"
let ISLOWQUALITY = "is_low_quality"
let RESTAURANTID = "restId"
let EMAILID = "emailid"
let PASSWORD = "PASSWORD"
let FIRSTNAME = "firstNAme"
let PHONENUMBER = "phone"
let OUTLETID = "outletid"
let OUTLETLOCATION = "outLetLoc"
let TRNNUMBER = "trnnumber"
let BRAND = "rest_brand"
let PROFILEIMAGE = "profilepic"
let LASTNAME = "lastname"
class AppConstants {
    static var authUserName = "System@CartandCook.com"
    static var authPassword = "api_C&C2@2!"
    struct BaseURL {
//        static let url = "http://10.1.12.30:90/api/"
        static let url =  "https://mobile.cartandcook.com/api/"
    }
    
    class func getBaseUrl() -> String {
        
        return BaseURL.url
    }
    
    class func getApiHeaders() -> [String: String] {
        let credentialData = "\(AppConstants.authUserName):\(AppConstants.authPassword)".data(using: .utf8)
       guard let cred = credentialData else { return ["" : ""] }
       let base64Credentials = cred.base64EncodedData(options: [])
       guard let base64Date = Data(base64Encoded: base64Credentials) else { return ["" : ""] }
       return ["Authorization": "Basic \(base64Date.base64EncodedString())"]
           
    }
    
}
extension UIImageView {
    func setImage(with url: URL?, placeHolderImage: UIImage? = UIImage(named:"user")) {
       
        kf.setImage(with: url, placeholder: placeHolderImage)
    }
    
    func setSupplierImage(with url: URL?, placeHolderImage: UIImage? = UIImage(named:"supplier")) {
       
        kf.setImage(with: url, placeholder: placeHolderImage)
    }
    
}
