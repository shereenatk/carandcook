//
//  MyOrderTVCell.swift
//  Cart & Cook
//
//  Created by Development  on 30/05/2021.
//

import Foundation
import UIKit
class MyOrderTVCell: UITableViewCell {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var statusIMageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalAMountLabel: UILabel!
    @IBOutlet weak var vatAmountLabel: UILabel!
    @IBOutlet weak var baseAmountLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    var timer = Timer()
    var orderNum = 0
}
