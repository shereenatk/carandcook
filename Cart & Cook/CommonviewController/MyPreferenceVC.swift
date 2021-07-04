//
//  MyPreferenceVC.swift
//  Cart & Cook
//
//  Created by Development  on 30/05/2021.
//

import Foundation
import UIKit
class MyPreferenceVC: UIViewController {
 
    @IBOutlet weak var highBtn: UIButton!
    @IBOutlet weak var lowBtn: UIButton!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var backgroundViewBtn: UIButton!
    @IBOutlet weak var selectionView: UIView!
    
    override func viewDidLoad() {
        if(self.isLowQuality()) {
            qualityLabel.text = "Low"
            lowBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        
        } else {
            qualityLabel.text = "High"
            highBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 0
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    @IBAction func openPopUp(_ sender: Any) {
        backgroundViewBtn.isHidden = false
        selectionView.isHidden = false
    }
    
    @IBAction func hideBackgroung(_ sender: Any) {
        backgroundViewBtn.isHidden = true
        selectionView.isHidden = true
    }
    
    @IBAction func highBtnSelected(_ sender: Any) {
        backgroundViewBtn.isHidden = true
        selectionView.isHidden = true
        UserDefaults.standard.setValue(false, forKey: ISLOWQUALITY)
        qualityLabel.text = "High"
        lowBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        highBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        
    }
    @IBAction func lowBtnselected(_ sender: Any) {
        backgroundViewBtn.isHidden = true
        selectionView.isHidden = true
        UserDefaults.standard.setValue(true, forKey: ISLOWQUALITY)
        qualityLabel.text = "Low"
            lowBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        
     
            highBtn.setImage(UIImage(systemName: "circler"), for: .normal)
        
    }
}
