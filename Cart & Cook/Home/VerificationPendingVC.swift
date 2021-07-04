//
//  VerificationPendingVC.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation
import UIKit
class VerificationPendingVC: UIViewController {
    
    @IBOutlet weak var statusView: UIView!{
        didSet{
            statusView.layer.borderColor = AppColor.colorGreen.cgColor
            statusView.layer.borderWidth = 1.0
            statusView.layer.masksToBounds = false
            statusView.layer.cornerRadius = 15
            statusView.layer.shadowOffset = CGSize(width: 0 , height:1)
        }
    }
    
    @IBAction func continueTohome(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "HomeViewControllerVC") as! HomeViewControllerVC
        pvc.fromVc = "verification"
            pvc.modalPresentationStyle =
                UIModalPresentationStyle.overCurrentContext
            self.present(pvc, animated: true, completion: nil)
    }
    
}
