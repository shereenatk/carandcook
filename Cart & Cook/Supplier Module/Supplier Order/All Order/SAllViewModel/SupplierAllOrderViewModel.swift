//
//  SupplierAllOrderViewModel.swift
//  Cart & Cook
//
//  Created by Development  on 23/06/2021.
//

import Foundation
class SupplierAllOrderViewModel {
    
 fileprivate let client = BaseAPIClient()
      var responseStatus: SupplierAllOrderModel?
   
    func getsupplierOrderList(supplierId: Int, orderId: Int, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        let custId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
        
        paramDict = [
            "SupplierID": supplierId,
            "CustomerID" : custId,
            "OrderID" : orderId
        ]
        client.makeNetworkRequest(requestObj: PageRouter.getSupplierOrderList(paramDict))  { (response: SupplierAllOrderModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
            self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
