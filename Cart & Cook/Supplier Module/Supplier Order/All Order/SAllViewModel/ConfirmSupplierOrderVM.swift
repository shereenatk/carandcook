//
//  ConfirmSupplierOrderVM.swift
//  Cart & Cook
//
//  Created by Development  on 30/06/2021.
//

import Foundation
class ConfirmSupplierOrderVM {
    
 fileprivate let client = BaseAPIClient()
      var responseStatus: AddSupplierModel?
   
    func supplierConfirmOrder(paramDict: [String: Any], onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
      
        client.makeNetworkRequest(requestObj: PageRouter.confirmsuplierOrder(paramDict))  { (response: AddSupplierModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
            self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
