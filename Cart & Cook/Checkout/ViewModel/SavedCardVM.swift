//
//  SavedCardVM.swift
//  Cart & Cook
//
//  Created by Development  on 24/06/2021.
//

import Foundation
class SavedCardVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: SavedCardsModel?
   
    func getSavedCards( onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        let cusId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
        var paramDict = [String: Any]()
        paramDict = ["CustomerID": cusId
        ]
        client.makeNetworkRequest(requestObj: PageRouter.getSavedCards(paramDict))  { (response: SavedCardsModel?, error) in
        print(paramDict)
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
