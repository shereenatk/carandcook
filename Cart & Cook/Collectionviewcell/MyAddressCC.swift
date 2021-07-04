//
//  MyAddressCC.swift
//  Cart & Cook
//
//  Created by Development  on 27/05/2021.
//

import Foundation
import UIKit
class MyAddressCC: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var outerView: ShadowView!
    var id = 0
    var coordinate = ""
    @IBOutlet weak var deleteBtn: UIButton!
}
