//
//  CartCC.swift
//  Cart & Cook
//
//  Created by Development  on 25/05/2021.
//

import Foundation
import UIKit
class CartCC: UICollectionViewCell {
    @IBOutlet weak var productImage: SquareImageView!
    var id = 0
    var selectedBtn = -1
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var actualPrice = 0.0
    @IBOutlet weak var offerView: UIView!{
        didSet{
            offerView.layer.cornerRadius = 10
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
    @IBOutlet weak var qtyLabel: UITextField!
    @IBOutlet weak var lowBtn: UIButton!{
        didSet{
            lowBtn.layer.cornerRadius = 10
            lowBtn.layer.masksToBounds = true
            lowBtn.backgroundColor = AppColor.colorPrice.value
            lowBtn.layer.borderColor = AppColor.priceBorderColor.cgColor
            lowBtn.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var highBtn: UIButton!{
        didSet{
            highBtn.layer.cornerRadius = 10
            highBtn.layer.masksToBounds = true
            highBtn.layer.borderWidth = 1
            highBtn.backgroundColor = AppColor.colorPrice.value
            highBtn.layer.borderColor = AppColor.priceBorderColor.cgColor
        }
    }
    
    @IBAction func deleteCartAction(_ sender: Any) {
        deleteTapAction?(self)
    }
    var deleteTapAction: ((CartCC) -> ())?
    var addTapAction: ((CartCC) -> ())?
     var subTapAction: ((CartCC) -> ())?
    @IBAction func substract(_ sender: Any) {
        subTapAction?(self)
    }
    
    @IBAction func addCart(_ sender: Any) {
        
        addTapAction?(self)
    }

    @IBOutlet weak var QlalityHeadLabel: UILabel!
    
//    @IBOutlet weak var qualityVar: UILabel!
    @IBOutlet weak var qltyview: UIView!

}
