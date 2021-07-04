//
//  FeedbackVM.swift
//  Cart & Cook
//
//  Created by Development  on 14/06/2021.
//

import Foundation
class FeedbackVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: FeedbackModel?
   
    func sentFeedback(paramDict: [String: Any], onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
 
        client.makeNetworkRequest(requestObj: PageRouter.sentFeedBack(paramDict))  { (response: FeedbackModel?, error) in
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
            
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
