//
//  OnlinePaymentVM.swift
//  Cart & Cook
//
//  Created by Development  on 01/08/2021.
//

import Foundation
import Foundation
class OnlinePaymentVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: OnlinePaymentModel?
   
    func makeOnlinePayment(paramDict: [String: Any], onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
       
        client.makeNetworkRequest(requestObj: PageRouter.makePaymnet(paramDict))  { (response: OnlinePaymentModel?, error) in
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
            
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
