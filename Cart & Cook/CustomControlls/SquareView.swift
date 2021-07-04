//
//  SquareView.swift
//  Site
//
//  Created by MAC on 23/01/2021.
//

import Foundation
import UIKit

class SquareView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    func initializeView() {
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0 , height:1)

    }
    
}
