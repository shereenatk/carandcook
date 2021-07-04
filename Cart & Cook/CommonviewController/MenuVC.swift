//
//  MenuVC.swift
//  Cart & Cook
//
//  Created by Development  on 30/05/2021.
//

import Foundation
import UIKit
import SideMenu
import CoreData
import Kingfisher
import SafariServices
class MenuVC: UIViewController {
@IBOutlet weak var profilePic: UIImageView! {
        didSet{
            profilePic.layer.borderWidth = 0
            profilePic.layer.masksToBounds = false
            profilePic.layer.borderColor = UIColor.black.cgColor
            profilePic.layer.cornerRadius = 50
            profilePic.clipsToBounds = true
        }
    }
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var topbtnsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topbtnView: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    let group = DispatchGroup()
override func viewDidLoad() {
    super.viewDidLoad()
   
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isHidden = true
     let fname = UserDefaults.standard.value(forKey: FIRSTNAME) as? String ?? ""
    let lname = UserDefaults.standard.value(forKey: LASTNAME)  as? String ?? ""
     let mail = UserDefaults.standard.value(forKey: EMAILID)  as? String ?? ""
    let phone = UserDefaults.standard.value(forKey: PHONENUMBER)  as? String ?? ""
    let rest = UserDefaults.standard.value(forKey: RESTAURANTNAME) as? String ?? ""
    nameLabel.text = fname + " " + lname
    mailLabel.text = mail
    phoneLabel.text = phone
    restName.text = rest
    if let active = UserDefaults.standard.value(forKey: ISACTIVATEDACCOUNT) as? Bool {
        if(!active) {
//            topbtnView.visibility = .gone
            topbtnView.isHidden = true
            topbtnsHeight.constant = 0
            logoutBtn.isHidden = false
        }
    }
}

override func viewWillAppear(_ animated: Bool) {

    if let navigationBar = self.navigationController?.navigationBar {
        for view in navigationBar.subviews{
            view.removeFromSuperview()
        }
    }
}
    
    @IBAction func myOrderaction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 4
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    @IBAction func savedAddress(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "MyAddressVC") as? MyAddressVC {
            vc.fromVc = "from menu"
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    @IBAction func managePreference(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MyPreferenceVC") as? MyPreferenceVC {
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    @IBAction func opencontactUs(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC {
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC {
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    private func changeRootView(){
        
        guard let window = UIApplication.shared.windows.first else { return }
        
        UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: {
            window.rootViewController = AppLandingNC()
        }, completion: nil)
        
    }
    @IBAction func websiteOpen(_ sender: Any) {
        if let url = URL(string: "https://cartandcook.com/") {
               let config = SFSafariViewController.Configuration()
               config.entersReaderIfAvailable = true

               let vc = SFSafariViewController(url: url, configuration: config)
               present(vc, animated: true)
           }
    }
    
    @IBAction func overView(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "OverViewVC") as? OverViewVC {
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    @IBAction func myProfile(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MyProfileVC") as? MyProfileVC {
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    @IBAction func logOutAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Log out" , message: "Are you sure to logout", preferredStyle: .alert)


        let ok = UIAlertAction(title: "Ok",  style: .default) { (SUCCESS) in
            self.group.enter()
            DispatchQueue.main.async {
                self.deleteAllData("AddressList")
                self.deleteAllData("CartList")
                self.deleteAllData("TimeSlotValues")
                self.deleteAllData("SupplierCart")
                UserDefaults.standard.removeObject(forKey: RESTAURANTNAME)
                UserDefaults.standard.removeObject(forKey: IS_FIRST_TIME)
                UserDefaults.standard.removeObject(forKey: IS_LOGIN)
                UserDefaults.standard.removeObject(forKey: USER_NAME)
                
                UserDefaults.standard.removeObject(forKey: USERID)
                UserDefaults.standard.removeObject(forKey: ISACTIVATEDACCOUNT)
                UserDefaults.standard.removeObject(forKey: CARTCOUNT)
                UserDefaults.standard.removeObject(forKey: SUPPLIERCARTCOUNT)
                UserDefaults.standard.removeObject(forKey: ISLOWQUALITY)
                
                UserDefaults.standard.removeObject(forKey: RESTAURANTID)
                UserDefaults.standard.removeObject(forKey: EMAILID)
                UserDefaults.standard.removeObject(forKey: PASSWORD)
                UserDefaults.standard.removeObject(forKey: FIRSTNAME)
                
                UserDefaults.standard.removeObject(forKey: PHONENUMBER)
                UserDefaults.standard.removeObject(forKey: OUTLETID)
                UserDefaults.standard.removeObject(forKey: PROFILEIMAGE)
                UserDefaults.standard.removeObject(forKey: LASTNAME)
                self.group.leave()
                }
            
            
            self.group.notify(queue: .main) {
              
                    self.changeRootView()
                }
            
        }
            
        let no = UIAlertAction(title: "No" , style: .default, handler: nil)

            alert.addAction(no)
            alert.addAction(ok)

//            self.dismiss(animated: true, completion: nil)
        self.present(alert, animated: true, completion: nil)
       
//        if let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC {
//            self.dismiss(animated: true, completion: {
//                window.present(alert, animated: true, completion: nil)
//                        })
//
//
////
//        }
    }
    

}
