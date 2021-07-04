//
//  getObjectVM.swift
//  Cart & Cook
//
//  Created by Development  on 23/05/2021.
//

import Foundation

class GetObjectVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: GetObjectModel?
   
    func getObjectData(fileNAme: String, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        paramDict = ["FileName": fileNAme]
        client.makeNetworkRequest(requestObj: PageRouter.getObject(paramDict))  { (response: GetObjectModel?, error) in

                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return

         }

     }
}
