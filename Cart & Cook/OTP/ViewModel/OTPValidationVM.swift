//
//  OTPValidationVM.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation
class OTPValidationVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: OTPValidationModel??
   
    func otpValidate(custId: Int, otp:Int, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        paramDict = [ "CustomerId": custId,
            "CustomerOTP": otp,
            
        ]
        client.makeNetworkRequest(requestObj: PageRouter.otpValidate(paramDict))  { (response: OTPValidationModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
