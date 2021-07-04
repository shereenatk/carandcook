//
//  RegisterViewModel.swift
//  Cart & Cook
//
//  Created by Development  on 19/05/2021.
//

import Foundation
class RegisterViewModel {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: RegisterModel?
   
    func registerUser(cuisine: String, outlet:String, emmail: String, mob: String, name: String, rName: String, rPhone: String, brand: String, vat: Int, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        paramDict = [ "CuisineType": cuisine,
            "OutletLocation": outlet,
            "OwnerEmail": emmail,
            "OwnerMobile": mob,
            "OwnerName": name,
            "RestaurantName": rName,
            "RestaurantPhone": rPhone,
            "Brand":brand,
            "VATNumber": vat
        ]
        client.makeNetworkRequest(requestObj: PageRouter.register(paramDict))  { (response: RegisterModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
