//
//  SupplierViewModel.swift
//  Cart & Cook
//
//  Created by Development  on 21/06/2021.
//

import Foundation
class SupplierViewModel {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: SupplierListmodel?
   
    func getSupplierList( onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        let restId = UserDefaults.standard.value(forKey: RESTAURANTID) as? Int ?? 0
        paramDict = [
                     "RestaurantId": restId
                     
        ]
        client.makeNetworkRequest(requestObj: PageRouter.supplierList(paramDict))  { (response: SupplierListmodel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}

