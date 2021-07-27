//
//  MyWalletVC.swift
//  Cart & Cook
//
//  Created by Development  on 27/07/2021.
//

import Foundation
import UIKit
class MyWalletVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var prepaidTf: UITextField!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        let priceList = self.outstangingAmountApi()
        self.balanceLabel.text = "AED " + "\(priceList[1])"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       return true
    }
}
