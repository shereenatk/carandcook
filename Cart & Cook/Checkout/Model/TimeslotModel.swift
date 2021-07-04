//
//  TimeslotModel.swift
//  Cart & Cook
//
//  Created by Development  on 26/05/2021.
//

import Foundation// MARK: - TimeslotModelElement
struct TimeslotModelElement: Codable {
    let slotID: Int?
    let slotDuration: String?

    enum CodingKeys: String, CodingKey {
        case slotID = "SlotID"
        case slotDuration = "SlotDuration"
    }
}

typealias TimeslotModel = [TimeslotModelElement]
