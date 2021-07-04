//
//  ThnakyouVC.swift
//  Cart & Cook
//
//  Created by Development  on 27/05/2021.
//

import Foundation
import UIKit
class ThnakyouVC: UIViewController {
  var fromVc = ""
    @IBAction func goToOrderDetails(_ sender: Any) {
        if(fromVc == "supplier") {
            if let vc =  UIStoryboard(name: "SupplierCart", bundle: nil).instantiateViewController(withIdentifier: "SupplierOrderListVC") as? SupplierOrderListVC {
                vc.supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
                self.navigationController?.pushViewController(vc, animated:   true)

            }
            
        } else {
            if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
                vc.selectedIndex = 4
                self.navigationController?.pushViewController(vc, animated:   true)

            }
        }
        
    }
    
}
