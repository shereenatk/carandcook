//
//  CartVC.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation
import UIKit
import CoreData
import SideMenu
class CartVC: UIViewController {
    var getobjectVM = GetObjectVM()
    @IBOutlet weak var emotyView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var cartCV: UICollectionView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var checkoutBtn: UIButton!{
        didSet{
            checkoutBtn.layer.backgroundColor = AppColor.colorGreen.cgColor
            checkoutBtn.layer.cornerRadius = 15
            
        }
    }
    var tableItems: [NSManagedObject] = []
    var totalamount = 0.0
    var subTotalAmount = 0.0
    var vatamount = 0.0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableItems = []
        if let count = UserDefaults.standard.value(forKey: CARTCOUNT) as? Int {
            if(count <= 0) {
                emotyView.isHidden = false
            } else {
                emotyView.isHidden = true
            }
        }
        getcartList()
    }
   
    override func viewDidLoad() {
        self.setupSideMenu()
       
        
    }
    
    
    
    @IBAction func menuAction(_ sender: Any) {

                                  
          if let left = SideMenuManager.defaultManager.leftMenuNavigationController{
              
              present(left, animated: true, completion: nil)
          }
                           
    }
    private func getcartList() {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "CartList")
        do {
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
        cartCV.reloadData()
        if(self.tableItems.count <= 0) {
            emotyView.isHidden = false
        } else {
            emotyView.isHidden = true
        }
        
    }
    
    private func updateTotalAmount()  {
         totalamount = 0.0
         subTotalAmount = 0.0
         vatamount = 0.0
        if(tableItems.count > 0) {
            for i in 0...tableItems.count - 1  {
                var price = 0.0
                var qty = 0
                let itemID = self.tableItems[i].value(forKey: "itemID") as? Int ?? 0
                if let isPromotionItem = self.tableItems[i].value(forKey: "isPromotionItem") as? Bool {
                    if(isPromotionItem){
                        if let actualprice = self.tableItems[i].value(forKey: "promotionPrice") as? Double {
                           price = actualprice
                        }
                    } else {
                       
                        if(self.getCartQuality(id: itemID) == "M") {
                            if let actualprice = self.tableItems[i].value(forKey: "priceLowQuality") as? Double {
                                price = actualprice
                            }
                        } else {
                            if let actualprice = self.tableItems[i
                            ].value(forKey: "priceHighQuality") as? Double {
                                price = actualprice
                            }
                            
                        }
                    }
                }
               
                if let cartCount = self.getCartCount(id: itemID) {
                  qty = cartCount
                }
                self.subTotalAmount = self.subTotalAmount + (Double(qty) * price)
               
            }
            self.vatamount = (self.subTotalAmount * 0.05)
            self.totalamount =    self.subTotalAmount + self.vatamount
            self.totalLabel.text = "AED " +  String(format: "%.2f", ceil(self.totalamount*100)/100)
            self.subTotalLabel.text = "AED " +  String(format: "%.2f", ceil(self.subTotalAmount*100)/100)
            self.vatLabel.text = "AED " + String(format: "%.2f", ceil(self.vatamount*100)/100)
        }


    }
    
    @IBAction func checkoutAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "CheckoutVC") as? CheckoutVC {
            self.navigationController?.pushViewController(vc, animated:   true)
        }
    }
    
    
    @IBAction func shopnowAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 1
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    @IBAction func searchProduct(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
}

extension  CartVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  cartCV.dequeueReusableCell(withReuseIdentifier: "CartCC", for: indexPath) as? CartCC else {
               return UICollectionViewCell()
          }
        var itemID = 0
        itemID = self.tableItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
        if let cartCount = self.getCartCount(id: itemID) {
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
       
        if let unint = self.tableItems[indexPath.row].value(forKey: "unit") as? String  {
        if let isPromotionItem = self.tableItems[indexPath.row].value(forKey: "isPromotionItem") as? Bool {
            if(isPromotionItem){
                cell.offerView.isHidden = false
                cell.QlalityHeadLabel.isHidden = true
                cell.qltyview.isHidden = true
                if let actualprice = self.tableItems[indexPath.row].value(forKey: "promotionPrice") as? Double {
                    cell.actualPriceLabel.text = "AED " +  String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
                  
                    
                }
            } else {
                cell.offerView.isHidden = true
                cell.QlalityHeadLabel.isHidden = false
                cell.qltyview.isHidden = false
               
                if(self.getCartQuality(id: itemID) == "M") {
                        if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
                            cell.actualPriceLabel.text = "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
//                            cell.qualityVar.text = "M"
                            cell.lowBtn.backgroundColor = AppColor.colorPrice.value
                            cell.lowBtn.layer.borderColor = AppColor.priceBorderColor.cgColor
                            cell.highBtn.backgroundColor = .white
                            cell.highBtn.layer.borderColor = UIColor.black.cgColor
                            cell.selectedBtn = 0
                        }
                    } else {
                        if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
                            cell.actualPriceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
//                            cell.qualityVar.text = "H"
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
//        }
        
        if(isConnectedToInternet()) {
            if let file_path = self.tableItems[indexPath.row].value(forKey: "image") as? String  {
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
      
        
        cell.addTapAction = { cell in
         var  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
            qty = qty + 1
            cell.subButton.isHidden = false
            cell.qtyLabel.isHidden = false
         cell.qtyLabel.text  = "\(qty)"
            var quality = ""
            if(cell.selectedBtn == 0) {
                quality = "M"
            } else {
                quality = "H"
            }
            self.updateCartCount(id: itemID, count: qty, quality: quality)
            self.updateTotalAmount()
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
                if(self.tableItems.count == 0) {
                    self.emotyView.isHidden = false
                } else {
                    self.emotyView.isHidden = true
                }
                self.cartCV.reloadData()
                
               }
      
            var quality = ""
            if(cell.selectedBtn == 0) {
                quality = "M"
            } else {
                quality = "H"
            }
            self.updateCartCount(id: itemID, count: qty, quality: quality)
            self.updateTotalAmount()
                  }
        cell.deleteTapAction = { cell in
              
                self.tableItems.remove(at: indexPath.row)
            if(self.tableItems.count == 0) {
                self.emotyView.isHidden = false
            } else {
                self.emotyView.isHidden = true
            }
                self.cartCV.reloadData()
             
      
            var quality = ""
            if(cell.selectedBtn == 0) {
                quality = "M"
            } else {
                quality = "H"
            }
            self.updateCartCount(id: itemID, count: 0, quality: quality)
            self.updateTotalAmount()
        }
        cell.highBtn.tag = indexPath.row
        cell.highBtn.addTarget(self, action: #selector(qualitySelectionHigh(_:)), for: .touchUpInside)
        cell.lowBtn.tag = indexPath.row
        cell.lowBtn.addTarget(self, action: #selector(qualitySelectionLow(_:)), for: .touchUpInside)
        let  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
        var quality = ""
        if(cell.selectedBtn == 0) {
            quality = "M"
        } else {
            quality = "H"
        }
        updateTotalAmount()
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
        guard let cell = self.cartCV.cellForItem(at: indexPath) as? CartCC else {
           return
       }
        cell.highBtn.backgroundColor = AppColor.colorPrice.value
        cell.highBtn.layer.borderColor = AppColor.priceBorderColor.cgColor
        if let actualprice = self.tableItems[sender.tag].value(forKey: "priceHighQuality") as? Double {
            let unint = self.tableItems[indexPath.row].value(forKey: "unit") as? String  ?? ""
            cell.actualPriceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
        }
        cell.lowBtn.backgroundColor = .white
        cell.lowBtn.layer.borderColor = UIColor.black.cgColor
        cell.selectedBtn = 1
        let  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
        
        updateCartCount(id: cell.id, count: qty, quality: "H")
        updateTotalAmount()
    }
    @objc func qualitySelectionLow(_ sender:UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = self.cartCV.cellForItem(at: indexPath) as? CartCC else {
           return
       }
        
        if let actualprice = self.tableItems[sender.tag].value(forKey: "priceLowQuality") as? Double {
            let unint = self.tableItems[indexPath.row].value(forKey: "unit") as? String  ?? ""
            cell.actualPriceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
        }
        cell.lowBtn.backgroundColor = AppColor.colorPrice.value
        cell.lowBtn.layer.borderColor = AppColor.priceBorderColor.cgColor
        cell.highBtn.backgroundColor = .white
        cell.highBtn.layer.borderColor = UIColor.black.cgColor
        cell.selectedBtn = 0
        let  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
       
        updateCartCount(id: cell.id, count: qty, quality: "M")
        updateTotalAmount()
    }
    
}

extension CartVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        guard let cell = self.cartCV.cellForItem(at: indexPath) as? CartCC else {
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

