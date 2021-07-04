//
//  MapProductVM.swift
//  Cart & Cook
//
//  Created by Development  on 22/06/2021.
//

import Foundation
class MapProductVM {
    
 fileprivate let client = BaseAPIClient()
      var responseStatus: MapProductM?
   
    func mapProducts(productId: String ,supplierId: Int, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        let custId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
        
        paramDict = [
                     "SupplierID": supplierId,
            "CustomerID" : custId,
            "ProductID" : productId
        ]
        client.makeNetworkRequest(requestObj: PageRouter.mapProducts(paramDict))  { (response: MapProductM?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
            self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
