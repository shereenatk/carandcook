//
//  BuyagainVC.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation
import UIKit
import SideMenu
import CoreData

class BuyagainVC: UIViewController {
    var weekList: [String] = []
    var selectedWeek = 0
    @IBOutlet weak var scrollview: UIScrollView!
    var tableItems: [NSManagedObject] = []
    let date = Date()
    let calendar = Calendar.current
    var dayOfWeek = 0
    static var quickDic : [[String:Any]] = [[:]]
    @IBOutlet weak var emotyView: UIView!
    var getobjectVM = GetObjectVM()
    override func viewDidLoad() {
        self.setupSideMenu()
        self.scrollview.contentSize.height = 1.0
        let components = calendar.dateComponents([.weekday], from: date)
        dayOfWeek = components.weekday ?? 0
        
        setDayButton()
        getTableList()
    }
    
    @IBAction func menuAction(_ sender: Any) {
          if let left =
                SideMenuManager.defaultManager.leftMenuNavigationController{
              
              present(left, animated: true, completion: nil)
          }
                           
    }
    
    fileprivate func getTableList() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "BuyAgain")
        do {
            self.tableItems = []
            fetchRequest.predicate = NSPredicate(format: "day = %@", "\(dayOfWeek)")
            let items = try managedContext.fetch(fetchRequest)
            if(items.count > 0) {
                for item in items {
                    if let itemTd =  item.value(forKey: "itemID") as? Int{
                        getProductList(type: itemTd)
                    }
                }
            } else {
                emotyView.isHidden = false
            }
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    private func getProductList(type: Int) {
       
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "ProductList")
        do {
            let sort = NSSortDescriptor(key:"item", ascending:true)
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(type)")
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                self.tableItems.append(item)
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        quickBuyCV.reloadData()
        if(self.tableItems.count <= 0) {
            emotyView.isHidden = false
        } else {
            emotyView.isHidden = true
        }
    }
    @IBAction func searchProduct(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    @IBOutlet weak var quickBuyCV: UICollectionView!
    private func setDayButton() {
        let components = calendar.dateComponents([.weekday], from: date)
       let dayOfWeek = components.weekday ?? 0
        switch dayOfWeek {
        case 1:
            self.weekList = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        case 2:
            self.weekList = [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday","Sunday"]
        case 3:
            self.weekList = [ "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Monday"]
        case 4:
            self.weekList = [ "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday"]
        case 5:
            self.weekList = [ "Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday"]
        case 6:
            self.weekList = [ "Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday"]
        case 7:
            self.weekList = [ "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        default:
            self.weekList = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        }
        
        
        var stickersScrollViewCount = 0
        
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 145.0
        let buttonHeight: CGFloat = 45.0
        let gapBetweenButtons: CGFloat = 10

        for i in 0..<7{
            stickersScrollViewCount = i
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = stickersScrollViewCount
            filterButton.layer.cornerRadius = 20
            
            filterButton.layer.borderWidth = 2
            filterButton.layer.borderColor = AppColor.colorPrimary.cgColor
            filterButton.backgroundColor = UIColor.clear
            filterButton.setTitleColor(UIColor.black, for: .normal)
            filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
            filterButton.showsTouchWhenHighlighted = true
            filterButton.setTitle(self.weekList[i], for: .normal)
            filterButton.addTarget(self, action:#selector(StickersActionTapped), for: .touchUpInside)
            filterButton.clipsToBounds = true
            xCoord +=  buttonWidth + gapBetweenButtons
            
            if filterButton.tag == selectedWeek {
                filterButton.backgroundColor = AppColor.colorPrimary.value
                filterButton.layer.borderColor = AppColor.colorPrimary.cgColor
                filterButton.setTitleColor(.white, for: .normal)
               
            } else {
                filterButton.backgroundColor = UIColor.white
                filterButton.setTitleColor(AppColor.colorPrimary.value, for: .normal)
            }
            
            
            scrollview.addSubview(filterButton)

        }
        scrollview.contentSize = CGSize(width: buttonWidth * CGFloat(stickersScrollViewCount+2), height: yCoord)
                   
        
    }
    @objc func StickersActionTapped(sender: UIButton) {
        selectedWeek = sender.tag
        if let title = sender.titleLabel?.text {
            switch title {
            case "Sunday":
                dayOfWeek = 1
            case  "Monday":
                dayOfWeek = 2
            case "Tuesday":
                dayOfWeek = 3
            case "Wednesday":
                dayOfWeek = 4
            case  "Thursday":
                dayOfWeek = 5
            case "Friday":
                dayOfWeek = 6
            case "Saturday":
                dayOfWeek = 7
            default:
                dayOfWeek = 1
            }
        }
        setDayButton()
        getTableList()
    }
    
    @IBAction func moveTocartAction(_ sender: Any) {
        
        if let cartcount = UserDefaults.standard.value(forKey: CARTCOUNT) as? Int {
            if(cartcount > 0) {
                let alert = UIAlertController(title: "", message: "Do you want to clear the existing cart ?", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                    let group = DispatchGroup()
                    group.enter()
                    self.deleteAllData("CartList")
                    group.leave()
                    group.notify(queue: .main) {
                      
                        for i in 0...self.tableItems.count - 1 {
                            let indexPath = IndexPath(row: i, section: 0)
                            guard let cell = quickBuyCV.cellForItem(at: indexPath) as? CartCC else {
                               return
                           }
                            let id = cell.id
                            let qty = cell.qtyLabel.text ?? "0"
                            var quality = ""
                            if(cell.selectedBtn == 0) {
                                quality = "M"
                            } else {
                                quality = "H"
                            }
                            self.updateCartCount(id: id, count: Int(qty) ?? 0, quality: quality)
                        }
                        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
                            vc.selectedIndex = 2
                            self.navigationController?.pushViewController(vc, animated:   true)

                        }
                        
                    
                }
                    
                   
                    
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                    for i in 0...self.tableItems.count - 1{
                        let indexPath = IndexPath(row: i, section: 0)
                        guard let cell = self.quickBuyCV.cellForItem(at: indexPath) as? CartCC else {
                           return
                       }
                        let id = cell.id
                        let qty = cell.qtyLabel.text ?? "0"
                        var quality = ""
                        if(cell.selectedBtn == 0) {
                            quality = "M"
                        } else {
                            quality = "H"
                        }
                        self.updateCartCount(id: id, count: Int(qty) ?? 0, quality: quality)
                    }
                    if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
                        vc.selectedIndex = 2
                        self.navigationController?.pushViewController(vc, animated:   true)

                    }
                }))

                self.present(alert, animated: true)
            } else {
                for i in 0...self.tableItems.count - 1{
                    let indexPath = IndexPath(row: i, section: 0)
                    guard let cell = self.quickBuyCV.cellForItem(at: indexPath) as? CartCC else {
                       return
                   }
                    let id = cell.id
                    let qty = cell.qtyLabel.text ?? "0"
                    var quality = ""
                    if(cell.selectedBtn == 0) {
                        quality = "M"
                    } else {
                        quality = "H"
                    }
                    
                    self.updateCartCount(id: id, count: Int(qty) ?? 0, quality: quality)
                }
                if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
                    vc.selectedIndex = 2
                    self.navigationController?.pushViewController(vc, animated:   true)

                }
            }
        }
     
    }
    
    @IBAction func quickCheckOutAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "CheckoutVC") as? CheckoutVC {
            BuyagainVC.quickDic = []
            for i in 0...self.tableItems.count - 1 {
                let indexPath = IndexPath(row: i, section: 0)
                if  let cell = quickBuyCV.cellForItem(at: indexPath) as? CartCC {
               
                let id = cell.id
                let qty = cell.qtyLabel.text ?? "0"
                    print(cell.actualPrice)
                let intqty = Int(qty) ?? 0
                    let quality = self.getBuyagainQuality(id: id) ?? "0"
                    let dict = [ "itemID" : id,"cartCount" : intqty, "quality" : quality, "price": cell.actualPrice] as [String : Any]
                BuyagainVC.quickDic.append(dict)
            }
            }
            vc.fromVc = "quickbuy"
          
            
            self.navigationController?.pushViewController(vc, animated:   true)
        }
    }
    
}
extension  BuyagainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  quickBuyCV.dequeueReusableCell(withReuseIdentifier: "CartCC", for: indexPath) as? CartCC else {
               return UICollectionViewCell()
          }
        var itemID = 0
        itemID = self.tableItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
        if let unint = self.tableItems[indexPath.row].value(forKey: "unit") as? String  {
           
        if let isPromotionItem = self.tableItems[indexPath.row].value(forKey: "isPromotionItem") as? Bool {
            if(isPromotionItem){
                cell.offerView.isHidden = false
                cell.QlalityHeadLabel.isHidden = true
                cell.qltyview.isHidden = true
                if let actualprice = self.tableItems[indexPath.row].value(forKey: "promotionPrice") as? Double {
                    cell.actualPriceLabel.text = "AED " +  String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
                    cell.actualPrice = actualprice
                }
            } else {
                cell.offerView.isHidden = true
                cell.QlalityHeadLabel.isHidden = false
                cell.qltyview.isHidden = false
               let x = self.getBuyagainQuality(id: itemID) 
                    if(self.getBuyagainQuality(id: itemID) == "M") {
                        
                        if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
                            cell.actualPrice = actualprice
                            cell.actualPriceLabel.text = "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
                            cell.lowBtn.backgroundColor = AppColor.colorPrice.value
                            cell.lowBtn.layer.borderColor = AppColor.priceBorderColor.cgColor
                            cell.highBtn.backgroundColor = .white
                            cell.highBtn.layer.borderColor = UIColor.black.cgColor
                            cell.selectedBtn = 0
                        }
                    } else {
                        if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
                            cell.actualPrice = actualprice
                            cell.actualPriceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
                            cell.highBtn.backgroundColor = AppColor.colorPrice.value
                            cell.highBtn.layer.borderColor = AppColor.priceBorderColor.cgColor
                            
                            cell.lowBtn.backgroundColor = .white
                            cell.lowBtn.layer.borderColor = UIColor.black.cgColor
                            cell.selectedBtn = 1
                        }
                    
                }
            }
        }
    }
        cell.discriptionLabel.text = self.tableItems[indexPath.row].value(forKey: "poductListModelDescription") as? String ?? ""
        cell.nameLabel.text = self.tableItems[indexPath.row].value(forKey: "item") as? String ?? ""
        cell.originLabel.text = self.tableItems[indexPath.row].value(forKey: "country") as? String ?? ""
//        if let  byted =  tableItems[indexPath.row].value(forKey: "thumbnail") as? Data {
//            cell.productImage.image = UIImage(data: byted as! Data, scale: 0.7)
////           cell.activityIndicator.stopAnimating()
//        }
        if(isConnectedToInternet()) {
            if let file_path = tableItems[indexPath.row].value(forKey: "image") as? String  {
                DispatchQueue.main.async {
                    self.getobjectVM.getObjectData(fileNAme: file_path){  isSuccess, errorMessage  in
                            var  fileBytes  = ""
                        if let  byte = self.getobjectVM.responseStatus?.fileBytes {
                            var encoded64 = byte
                            let remainder = encoded64.count % 4
                            if remainder > 0 {
                                encoded64 = encoded64.padding(toLength: encoded64.count + 4 - remainder,
                                                              withPad: "=",
                                                              startingAt: 0)
                            }
                            let dataDecoded : Data = Data(base64Encoded: encoded64, options: .ignoreUnknownCharacters)!
                            let decodedimage = UIImage(data: dataDecoded, scale: 1)

                            cell.productImage.image = decodedimage
                        }

                    }
                }
            }

        }
        
       
        if let cartCount = self.getBuyagainCount(id: itemID) {
            if(cartCount > 0) {
                cell.subButton.isHidden = false
                cell.qtyLabel.isHidden = false
                cell.qtyLabel.text = "\(cartCount)"
            } else {
                cell.subButton.isHidden = true
                cell.qtyLabel.isHidden = true
               
            }
            
        }
        cell.id = itemID
        cell.addTapAction = { cell in
         var  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
            qty = qty + 1
            cell.subButton.isHidden = false
            cell.qtyLabel.isHidden = false
         cell.qtyLabel.text  = "\(qty)"
           
        }
        cell.qtyLabel.delegate = self
        cell.qtyLabel.tag = indexPath.row
        cell.subTapAction = { cell in
                  
            var  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
               if(qty > 1) {
                  qty = qty - 1
            
                cell.qtyLabel.text  = "\(qty)"
                cell.subButton.isHidden = false
                cell.qtyLabel.isHidden = false
             
               } else {
                qty = qty - 1
                cell.subButton.isHidden = true
                cell.qtyLabel.isHidden = true
                self.tableItems.remove(at: indexPath.row)
                self.quickBuyCV.reloadData()
               }
      
            
                  }
        cell.deleteTapAction = { cell in
            self.tableItems.remove(at: indexPath.row)
            self.quickBuyCV.reloadData()
        }
        cell.highBtn.tag = indexPath.row
        cell.highBtn.addTarget(self, action: #selector(qualitySelectionHigh(_:)), for: .touchUpInside)
        cell.lowBtn.tag = indexPath.row
        cell.lowBtn.addTarget(self, action: #selector(qualitySelectionLow(_:)), for: .touchUpInside)
        return cell
    }
    
   
   
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? CartCC else {
                                       return
                                   }
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
            vc.itemId = cell.id
            vc.image = cell.productImage.image
            self.navigationController?.pushViewController(vc, animated:   true)

        }
       }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20)
        
       
        
//        if(self.isLowQuality()) {
//            if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
//                if(actualprice > 0) {
//                    return CGSize(width: width, height: 200)
//                } else {
//                    return CGSize(width: 0, height: 0)
//                }
//            }
//        }else if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
//                if(actualprice > 0) {
//                    return CGSize(width: width, height: 200)
//                } else {
//                    return CGSize(width: 0, height: 0)
//                }
//            } else {
//                return CGSize(width: 0, height: 0)
//
//        }
//
        return CGSize(width: width, height: 160)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    @objc func qualitySelectionHigh(_ sender:UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = self.quickBuyCV.cellForItem(at: indexPath) as? CartCC else {
           return
       }
        cell.highBtn.backgroundColor = AppColor.colorPrice.value
        cell.highBtn.layer.borderColor = AppColor.priceBorderColor.cgColor
        
        cell.lowBtn.backgroundColor = .white
        cell.lowBtn.layer.borderColor = UIColor.black.cgColor
        cell.selectedBtn = 1
        
    }
    @objc func qualitySelectionLow(_ sender:UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = self.quickBuyCV.cellForItem(at: indexPath) as? CartCC else {
           return
       }
       
        cell.lowBtn.backgroundColor = AppColor.colorPrice.value
        cell.lowBtn.layer.borderColor = AppColor.priceBorderColor.cgColor
        cell.highBtn.backgroundColor = .white
        cell.highBtn.layer.borderColor = UIColor.black.cgColor
        cell.selectedBtn = 0
    }
    
    
}

extension BuyagainVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        let indexPath = IndexPath(row: textField.tag, section: 0)
        guard let cell = self.quickBuyCV.cellForItem(at: indexPath) as? CartCC else {
           return
       }
        if let count = textField.text {
            let cpountInt = Int(count) ?? 0
            var quality = ""
            if(cell.selectedBtn == 0) {
                quality = "M"
            } else {
                quality = "H"
            }
            let id = cell.id
            self.updateCartCount(id: id, count: cpountInt, quality: quality)
        }
    }
}
