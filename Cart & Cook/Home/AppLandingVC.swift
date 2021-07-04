//
//  AppLandingVC.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//


import Foundation
import UIKit

class AppLandingNC : UINavigationController {
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpRootVC()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setUpRootVC(){
         
//            if let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as?  HomeTabBarControllerViewController {
//
//                   self.viewControllers = [vc]
//
//            }
        
             if let _ = UserDefaults.standard.value(forKey: IS_LOGIN)  {
                if let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as?  HomeTabBarControllerViewController {
               
                                  self.viewControllers = [vc]
               
                           }
                                                    
                     }
                  else {
                     if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginviewControllerVC") as?  LoginviewControllerVC {
                       
                            self.viewControllers = [vc]
                                                    
                     }
                 }
       
        }
       
    
}
