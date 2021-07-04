//
//  ProductListCVCell.swift
//  Cart & Cook
//
//  Created by Development  on 24/05/2021.
//

import Foundation
import UIKit
class ProductListCVCell: UICollectionViewCell {
    @IBOutlet weak var productImage: SquareImageView!
    var id = 0
    @IBOutlet weak var offerView: SquareView!{
        didSet{
            offerView.startShimmeringEffect()
        }
    }
    
    @IBOutlet weak var actualPriceLabel: UILabel!{
        didSet{
            actualPriceLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var discriptionLabel: UILabel!
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    
    @IBOutlet weak var qtyView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var qtyLabel: UITextField!{
        didSet{
            qtyLabel.layer.cornerRadius = 15
            qtyLabel.layer.masksToBounds = true
        }
    }
    var addTapAction: ((ProductListCVCell) -> ())?
     var subTapAction: ((ProductListCVCell) -> ())?
    @IBAction func substract(_ sender: Any) {
        subTapAction?(self)
    }
    
    @IBAction func addCart(_ sender: Any) {
        
        addTapAction?(self)
    }

 
}
