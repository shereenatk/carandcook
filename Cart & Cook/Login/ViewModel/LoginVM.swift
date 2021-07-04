//
//  LoginVM.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation
class LoginVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: LoginModel?
   
    func loginUser(email: String, password:String,  onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        paramDict = [ "EmailAddress": email,
            "Password": password,
            
        ]
        client.makeNetworkRequest(requestObj: PageRouter.login(paramDict))  { (response: LoginModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
