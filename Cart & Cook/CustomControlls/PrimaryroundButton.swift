//
//  PrimaryroundButton.swift
//  Cart & Cook
//
//  Created by Development  on 19/05/2021.
//

import Foundation
import UIKit

class PrimaryroundButton: UIButton {
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
        self.layer.borderColor = AppColor.colorGreen.value.cgColor
        self.layer.backgroundColor = AppColor.colorGreen.cgColor
        self.layer.borderWidth = 3
        self.layer.masksToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 0.5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = AppColor.colorGreen.cgColor
        self.setTitleColor(.white, for: .normal)
        self.layer.shadowOffset = CGSize(width: 0 , height:1)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
}
