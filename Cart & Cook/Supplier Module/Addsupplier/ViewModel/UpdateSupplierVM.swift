//
//  UpdateSupplierVM.swift
//  Cart & Cook
//
//  Created by Development  on 23/06/2021.
//

import Foundation
class UpdateSupplierVM {
    
 fileprivate let client = BaseAPIClient()
      var responseStatus: AddSupplierModel?
   
    func addOrEditSupplier(paramDict : [String: Any], onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        
        client.makeNetworkRequest(requestObj: PageRouter.updateSupplier(paramDict))  { (response: AddSupplierModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
            self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
