//
//  CategoryListVM.swift
//  Cart & Cook
//
//  Created by Development  on 23/06/2021.
//

import Foundation
class CategoryListVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: CategoryListModel?
   
    func getCategoryList( onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        
        client.makeNetworkRequest(requestObj: PageRouter.getCategory)  { (response: CategoryListModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}

