//
//  SupplierPalceOrderVM.swift
//  Cart & Cook
//
//  Created by Development  on 29/06/2021.
//

import Foundation
class SupplierPalceOrderVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: SupplierPlaceOrderM?
   
    func placeOrder(paramDict: [String: Any], onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {

        client.makeNetworkRequest(requestObj: PageRouter.supplierPlaceOrder(paramDict))  { (response: SupplierPlaceOrderM?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
