//
//  TopDelasTVCell.swift
//  Cart & Cook
//
//  Created by Development  on 23/05/2021.
//

import Foundation
import UIKit
class TopDelasTVCell: UITableViewCell {
    var id = 0
    @IBOutlet weak var productImage: SquareImageView!
    
    @IBOutlet weak var offerView: SquareView!{
        didSet{
            offerView.startShimmeringEffect()
            offerView.backgroundColor = .red
        }
    }
    
    @IBOutlet weak var actualPriceLabel: UILabel!{
        didSet{
            actualPriceLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    {
        didSet{
            offerPriceLabel.sizeToFit()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    
    @IBOutlet weak var qtyView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!{
        didSet{
            qtyLabel.layer.cornerRadius = 15
            qtyLabel.layer.masksToBounds = true
        }
    }
    var addTapAction: ((TopDelasTVCell) -> ())?
     var subTapAction: ((TopDelasTVCell) -> ())?
    @IBAction func substract(_ sender: Any) {
        subTapAction?(self)
    }
    
    @IBAction func addCart(_ sender: Any) {
        
        addTapAction?(self)
    }
}
