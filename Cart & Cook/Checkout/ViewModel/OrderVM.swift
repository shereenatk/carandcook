//
//  OrderVM.swift
//  Cart & Cook
//
//  Created by Development  on 30/05/2021.
//

import Foundation
class OrderVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: OrderModel?
   
    func placeOrder(paramDict: [String: Any], onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {

        client.makeNetworkRequest(requestObj: PageRouter.placeOrder(paramDict))  { (response: OrderModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
