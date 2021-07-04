//
//  SAllOrderTVCell.swift
//  Cart & Cook
//
//  Created by Development  on 23/06/2021.
//

import Foundation
import UIKit
class SAllOrderTVCell : UITableViewCell {
    var orderNum = 0
    var supplierId = 0
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIMageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var subTotalLabe: UILabel!
    @IBOutlet weak var sNameLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
}
