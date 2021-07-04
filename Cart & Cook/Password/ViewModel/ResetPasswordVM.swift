//
//  ResetPasswordVM.swift
//  Cart & Cook
//
//  Created by Development  on 31/05/2021.
//

import Foundation
class ResetPasswordVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: ResetPasswordModel?
   
    func resetPassword( password: String, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        if let id = UserDefaults.standard.value(forKey: EMAILID) as? String {
            paramDict = [ "EmailAddress": id,
                          "Password": password
            ]
            client.makeNetworkRequest(requestObj: PageRouter.resetPassword(paramDict))  { (response: ResetPasswordModel?, error) in
                
                     if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                     self.responseStatus = response
                         DispatchQueue.main.async {onCompletion(false, nil)}
                         return
                 
             }
        }
       
         
     }
}
