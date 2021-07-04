//
//  AddSubProductTC.swift
//  Cart & Cook
//
//  Created by Development  on 21/06/2021.
//

import Foundation
import UIKit
class AddSubProductTC : UITableViewCell {
    var productId = 0
    @IBOutlet weak var addbtn: UIButton!{
        didSet{
            addbtn.layer.cornerRadius = 10
            addbtn.layer.borderColor = UIColor.lightGray.cgColor
            addbtn.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}
