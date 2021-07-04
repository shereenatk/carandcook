//
//  PoductListVM.swift
//  Cart & Cook
//
//  Created by Development  on 23/05/2021.
//

import Foundation
class PoductListVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus:  PoductListModel?
   
    func getProductList( onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
       
        client.makeNetworkRequest(requestObj: PageRouter.productList)  { (response: PoductListModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
