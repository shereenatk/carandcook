//
//  OverDueVM.swift
//  Cart & Cook
//
//  Created by Development  on 27/07/2021.
//

import Foundation
class OverDueVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: OverDueModel?
   
    func getOverDueAmount( onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        paramDict = [
                      "CustomerID" : UserDefaults.standard.value(forKey: USERID) ?? 0
        ]
        client.makeNetworkRequest(requestObj: PageRouter.getOutstandingAmount(paramDict))  { (response: OverDueModel?, error) in
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
            
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
