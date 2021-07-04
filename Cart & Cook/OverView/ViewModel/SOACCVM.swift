//
//  SOACCVM.swift
//  Cart & Cook
//
//  Created by Development  on 20/06/2021.
//

import Foundation
class SOACCVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: SOACCModel?
   
    func getSOACCList(startDate: String,endDate : String, type: String, onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        var paramDict = [String: Any]()
        let cusId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
        let restId = UserDefaults.standard.value(forKey: RESTAURANTID) as? Int ?? 0
        let outLocId = UserDefaults.standard.value(forKey: OUTLETID) as? Int ?? 0
        paramDict = ["CustomerId": cusId,
                     "RestaurantId": restId,
                     "OutletLocationId": outLocId,
                     "Startdate" : startDate,
                     "Enddate" : endDate,
                        "Type" : type
                     
        ]
        client.makeNetworkRequest(requestObj: PageRouter.soaCC(paramDict))  { (response: SOACCModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
