//
//  MyProfileVC.swift
//  Cart & Cook
//
//  Created by Development  on 16/06/2021.
//

import Foundation
import UIKit
class MyProfileVC: UIViewController {
    @IBOutlet weak var phoneLabel: UILabel!
   
    @IBOutlet weak var vatNumber: UITextField!
    @IBOutlet weak var brandName: UITextField!
    @IBOutlet weak var outletLocatyionTf: UITextField!
    @IBOutlet weak var restName: UITextField!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    let pickerView = ToolbarPickerView()
    @IBAction func backAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 0
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    override func viewDidLoad() {
        
         let fname = UserDefaults.standard.value(forKey: FIRSTNAME) as? String ?? ""
        let lname = UserDefaults.standard.value(forKey: LASTNAME)  as? String ?? ""
         let mail = UserDefaults.standard.value(forKey: EMAILID)  as? String ?? ""
        let phone = UserDefaults.standard.value(forKey: PHONENUMBER)  as? String ?? ""
        let rest = UserDefaults.standard.value(forKey: RESTAURANTNAME) as? String ?? ""
        let restLoc = UserDefaults.standard.value(forKey: OUTLETLOCATION) as? String ?? ""
        let bardnd = UserDefaults.standard.value(forKey: BRAND) as? String ?? ""
        let vat = UserDefaults.standard.value(forKey: TRNNUMBER) as? String ?? ""
        nameLabel.text = fname + " " + lname
        mailLabel.text = mail
        phoneLabel.text = phone
        restName.text = "  " + rest
        outletLocatyionTf.text = "  " + restLoc
        brandName.text = "  " + bardnd
        vatNumber.text = "  " + vat
    }
    
    
}



