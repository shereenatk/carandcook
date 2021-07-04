//
//  DateExtension.swift
//  Cart & Cook
//
//  Created by Development  on 01/06/2021.
//

import Foundation
import UIKit
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func toCurrentTimezone() -> Date {
        let timeZoneDifference =
        TimeInterval(TimeZone.current.secondsFromGMT())
        return self.addingTimeInterval(timeZoneDifference)
   }
}
