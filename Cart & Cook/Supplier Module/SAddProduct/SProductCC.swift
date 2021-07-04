//
//  SProductCC.swift
//  Cart & Cook
//
//  Created by Development  on 22/06/2021.
//

import Foundation
import UIKit
class SProductCC: UICollectionViewCell {
    var productId = 0
    var total = 0.0
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!{
        didSet{
            priceLabel.layer.borderColor = UIColor.lightGray.cgColor
            priceLabel.layer.cornerRadius = 10
            priceLabel.layer.borderWidth = 0.5
        }
    }
    var addTapAction: ((SProductCC) -> ())?
     var subTapAction: ((SProductCC) -> ())?
    var deleteTapAction: ((SProductCC) -> ())?
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var qtyLabel: UITextField!{
        didSet{
            qtyLabel.layer.cornerRadius = 15
            qtyLabel.layer.masksToBounds = true
        }
    }
    @IBAction func deleteCartAction(_ sender: Any) {
        deleteTapAction?(self)
    }
   
    @IBOutlet weak var qltyview: UIView!
    @IBAction func substract(_ sender: Any) {
        subTapAction?(self)
    }
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBAction func addCart(_ sender: Any) {
        
        addTapAction?(self)
    }
    
}
