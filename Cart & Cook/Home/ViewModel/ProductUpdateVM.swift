//
//  ProductUpdateVM.swift
//  Cart & Cook
//
//  Created by Development  on 30/06/2021.
//

import Foundation
class ProductUpdateVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus:  PriceUpdateModel?
   
    func getPriceUpdate (onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
       
        client.makeNetworkRequest(requestObj: PageRouter.priceUpdate)  { (response: PriceUpdateModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
