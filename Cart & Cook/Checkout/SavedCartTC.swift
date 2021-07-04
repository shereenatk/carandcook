//
//  SavedCartTC.swift
//  Cart & Cook
//
//  Created by Development  on 24/06/2021.
//

import Foundation
import UIKit
class SavedCardTC: UITableViewCell {
    var cardId = 0
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var outerView: ShadowView!
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var expiryLabel: UILabel!
}
