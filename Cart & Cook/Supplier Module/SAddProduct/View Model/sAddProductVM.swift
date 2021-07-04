//
//  sAddProductVM.swift
//  Cart & Cook
//
//  Created by Development  on 22/06/2021.
//

import Foundation
class SAddProductVM {
    
 fileprivate let client = BaseAPIClient()
     static var responseStatus: SAddProductM?
   
    func getProductList(supplierID : Int,onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
      
        let restId = UserDefaults.standard.value(forKey: RESTAURANTID) as? Int ?? 0
        paramDict = [
                     "RestaurantId": restId,
            "SupplierID" : supplierID
        ]
        client.makeNetworkRequest(requestObj: PageRouter.getProductList(paramDict))  { (response: SAddProductM?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
            SAddProductVM.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
