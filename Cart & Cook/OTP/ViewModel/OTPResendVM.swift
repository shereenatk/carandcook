//
//  OTPResendVM.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//
import Foundation
class OTPResendVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: OTPResendModel??
   
    func otpResent(custId: Int, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        paramDict = [ "CustomerId": custId
            
        ]
        client.makeNetworkRequest(requestObj: PageRouter.otpResent(paramDict))  { (response: OTPResendModel?, error) in
            var responseStatus = response
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
