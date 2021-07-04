//
//  TimeslotCC.swift
//  Cart & Cook
//
//  Created by Development  on 26/05/2021.
//

import Foundation
import UIKit
class TimeslotCC: UICollectionViewCell {
    @IBOutlet weak var timeBtn: UIButton!{
        didSet{
            timeBtn.layer.cornerRadius = 5
            timeBtn.layer.borderColor = UIColor.lightGray.cgColor
            timeBtn.layer.borderWidth = 1
        }
    }
    var slotId = 0
}
