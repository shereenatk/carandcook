//
//  TimeSlotVM.swift
//  Cart & Cook
//
//  Created by Development  on 26/05/2021.
//

import Foundation
class TimeSlotVM {
    
 fileprivate let client = BaseAPIClient()
     var responseStatus: TimeslotModel?
   
    func getTimeSlotList( onCompletion: @escaping (_ isSuccess: Bool, _ errorMessage: (ResponseError?)) -> Void) {
        
        client.makeNetworkRequest(requestObj: PageRouter.getTimeSlot)  { (response: TimeslotModel?, error) in
        
                 if let error = error { DispatchQueue.main.async {onCompletion(false, error)}; return }
                 self.responseStatus = response
                     DispatchQueue.main.async {onCompletion(false, nil)}
                     return
             
         }
         
     }
}
