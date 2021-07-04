//
//  HomeTabBarControllerViewController.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import UIKit

class HomeTabBarControllerViewController: UITabBarController,  UITabBarControllerDelegate {
    var categoriesVC: CategoriesVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesVC = self.viewControllers![1] as? CategoriesVC
        if let items = self.tabBar.items {
            print("\(items[1])")
            let cartcount = UserDefaults.standard.value(forKey: CARTCOUNT) as? Int ?? 0
            items[2].badgeValue = "\(cartcount)"
            
          }
        if #available(iOS 10.0, *)
           {
            self.tabBar.items![2].badgeColor = AppColor.colorGreen.value
           }
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let titl = item.title {
            if(titl == "Categories") {

                guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
                    return
                }
                if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
                    vc.selectedIndex = 1
                    window.pushViewController(vc, animated:   false)

                }

            }
        }
    }
    
}
