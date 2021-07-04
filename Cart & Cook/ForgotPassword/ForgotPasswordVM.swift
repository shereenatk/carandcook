//
//  ForgotPasswordVM.swift
//  Cart & Cook
//
//  Created by Development  on 30/06/2021.
//

import Foundation
class ForgotPasswordVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: RegisterModel?
   
    func forgotPassword( emmail: String, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        paramDict = [
            "EmailAddress": emmail
        ]
        client.makeNetworkRequest(requestObj: PageRouter.forgotPassword(paramDict))  { (response: RegisterModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
