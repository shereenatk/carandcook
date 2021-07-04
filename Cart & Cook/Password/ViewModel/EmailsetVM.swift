//
//  EmailsetVM.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation
class EmailsetVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: EmailSetModel??
   
    func setPassword(custId: Int, password: String, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        paramDict = [ "CustomerId": custId,
                      "CustomerPassword": password
        ]
        client.makeNetworkRequest(requestObj: PageRouter.setPassword(paramDict))  { (response: EmailSetModel?, error) in
            
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
