//
//  MyOrderVM.swift
//  Cart & Cook
//
//  Created by Development  on 30/05/2021.
//

import Foundation
class MyOrderVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: MyOrderModel?
   
    func getMyOrderList(orderId: Int, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        paramDict = [ "OrderID": orderId,
                      "CustomerID" : UserDefaults.standard.value(forKey: USERID) ?? 0
        ]
        print(paramDict)
        client.makeNetworkRequest(requestObj: PageRouter.getMyOrder(paramDict))  { (response: MyOrderModel?, error) in
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
            
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
