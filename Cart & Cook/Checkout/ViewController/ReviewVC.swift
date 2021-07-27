//
//  ReviewVC.swift
//  Cart & Cook
//
//  Created by Development  on 27/05/2021.
//

import Foundation
import UIKit
import CoreData
class ReviewVC: UIViewController {
    var address = ""
    var time = ""
    var addresId = 0
    var fromVc = ""
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    var totalamount = 0.0
    var subTotalAmount = 0.0
    var vatamount = 0.0
    @IBOutlet weak var reviewCV: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var tableItems: [NSManagedObject] = []
    override func viewDidLoad() {
        if(fromVc != "quickbuy") {
            getcartList()
        } else {
            for item in BuyagainVC.quickDic {
             let itemTd =    item["itemID"] as? Int ?? 0
                getProductList(type: itemTd)
            }
          
        }
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString1 = formatter.string(from: now)
        var timeValue = "Delivery Date: " + dateString1
        timeValue = timeValue + "\n" + "Time: " + self.time
        addressLabel.text = address + "\n \n" + timeValue
    }
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            backBtn.layer.cornerRadius = 15
            
        }
    }
    @IBOutlet weak var addressLabel: UILabel!
    @IBAction func goToAddressCheckout(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "CheckoutVC") as? CheckoutVC {
            self.navigationController?.pushViewController(vc, animated:   true)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 2
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    @IBOutlet weak var cvHeight: NSLayoutConstraint!
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
            for item in items {
                if let itemTd =  item.value(forKey: "itemID") as? Int{
                   
                    getProductList(type: itemTd)
                    
                }
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
        cvHeight.constant = CGFloat(tableItems.count * 75 + 50)
        reviewCV.reloadData()
        if(fromVc != "quickbuy") {
            updateTotalAmount()
        }
//        else {
//            updateBuyagainAmount()
//        }
//
    }
    
    
    @IBAction func paymnet(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC {
            let total = self.subTotalLabel.text
            vc.total = total ?? ""
            vc.totalAmount = self.subTotalAmount
            vc.subtotal = self.subTotalLabel.text ?? ""
            vc.fullTotal = self.totalLabel.text ?? ""
            vc.vat = self.vatLabel.text ?? ""
            vc.addresId = self.addresId
            vc.timeSlote = self.time
            vc.fromVc = self.fromVc
            vc.tableItems = self.tableItems
            self.navigationController?.pushViewController(vc, animated:   true)
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
                self.vatamount = (self.subTotalAmount * 0.05)
                self.totalamount =    self.subTotalAmount + self.vatamount
                self.totalLabel.text = "AED " +  String(format: "%.2f", ceil(self.totalamount*100)/100)
                self.subTotalLabel.text = "AED " +  String(format: "%.2f", ceil(self.subTotalAmount*100)/100)
                self.vatLabel.text = "AED " + String(format: "%.2f", ceil(self.vatamount*100)/100)
            }
        }
    }
    
    private func updateBuyagainAmount()  {
         totalamount = 0.0
         subTotalAmount = 0.0
         vatamount = 0.0
        if(BuyagainVC.quickDic.count > 0) {
            for i in 0...BuyagainVC.quickDic.count - 1  {
                let indexPath = IndexPath(row: i, section: 0)
                
                guard let cell = reviewCV.cellForItem(at: indexPath) as? ReviewCC else {
                   return
               }
                let totalString =  cell.totalLabel.text ?? ""
                if let totalVal = Double(totalString) {
                    self.subTotalAmount = self.subTotalAmount + totalVal
                    self.vatamount = (self.subTotalAmount * 0.05)
                    self.totalamount =    self.subTotalAmount + self.vatamount
                    self.totalLabel.text = "AED " +  String(format: "%.2f", ceil(self.totalamount*100)/100)
                    self.subTotalLabel.text = "AED " +  String(format: "%.2f", ceil(self.subTotalAmount*100)/100)
                    self.vatLabel.text = "AED " + String(format: "%.2f", ceil(self.vatamount*100)/100)
                }
                
                
               
            }
        }


    }
    
}
extension  ReviewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  reviewCV.dequeueReusableCell(withReuseIdentifier: "ReviewCC", for: indexPath) as? ReviewCC else {
               return UICollectionViewCell()
          }
      let unint = self.tableItems[indexPath.row].value(forKey: "unit") as? String  ?? ""
            var itemID = 0
            itemID = self.tableItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
   let isPromotionItem = self.tableItems[indexPath.row].value(forKey: "isPromotionItem") as? Bool  ?? false
          
            
            
            
            if(fromVc != "quickbuy") {
                if(isPromotionItem){
                    if let actualprice = self.tableItems[indexPath.row].value(forKey: "promotionPrice") as? Double {
                        
                        var itemID = 0
                        itemID = self.tableItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
                            cell.priceLabel.text = "AED " +  String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
                            if let cartCount = self.getCartCount(id: itemID) {
                                if(cartCount > 0) {
                                    
                                    cell.qtyLabel.isHidden = false
                                    cell.qtyLabel.text = "Quantity: " + "\(cartCount)"
                                    let tota = Double(cartCount) * actualprice
                                    cell.totalLabel.text = "AED " +  String(format: "%.2f", ceil(tota*100)/100)
                                    
                                } else {
                                   
                                    cell.qtyLabel.isHidden = true
                                   
                                }
                                
                            }
                        
                    }
                } else if(self.getCartQuality(id: itemID) == "M") {
                            if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
                                    if let cartCount = self.getCartCount(id: itemID) {
                                        if(cartCount > 0) {
                                            cell.priceLabel.text = "AED " +  String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
                                            cell.qtyLabel.isHidden = false
                                            cell.qtyLabel.text = "Quantity: " + "\(cartCount)"
                                            let tota = Double(cartCount) * actualprice
                                            cell.totalLabel.text = "AED " + String(format: "%.2f", ceil(tota*100)/100)
                                        } else {
                                           
                                            cell.qtyLabel.isHidden = true
                                        }
                                    }
                                
                            }
                } else {
                    if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
                        cell.priceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
                        var itemID = 0
                        itemID = self.tableItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
                        if(fromVc != "quickbuy") {
                            if let cartCount = self.getCartCount(id: itemID) {
                                if(cartCount > 0) {
                                    
                                    cell.qtyLabel.isHidden = false
                                    cell.qtyLabel.text = "Quantity: " + "\(cartCount)"
                                    let tota = Double(cartCount) * actualprice
                                    cell.totalLabel.text = "AED " + String(format: "%.2f", ceil(tota*100)/100)
                                } else {
                                   
                                    cell.qtyLabel.isHidden = true
                                   
                                }
                                
                            }
                        }
                    }
                }
            }
             else {
                for item in BuyagainVC.quickDic {
                 let itemTd =    item["itemID"] as? Int ?? 0
                    if(itemID == itemTd){
                        if let cartCount =  item["cartCount"] as? Int {
                            if(cartCount > 0) {
                                
                                cell.qtyLabel.isHidden = false
                                cell.qtyLabel.text = "Quantity: " + "\(cartCount)"
                                let actualprice =  item["price"] as? Double ?? 0.0
                                cell.priceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
                                let tota = Double(cartCount) * actualprice
                                cell.totalLabel.text = "AED " + String(format: "%.2f", ceil(tota*100)/100)
                                self.subTotalAmount = self.subTotalAmount + (Double(cartCount) * tota)
                                self.vatamount = (self.subTotalAmount * 0.05)
                                self.totalamount =    self.subTotalAmount + self.vatamount
                                self.totalLabel.text = "AED " +  String(format: "%.2f", ceil(self.totalamount*100)/100)
                                self.subTotalLabel.text = "AED " +  String(format: "%.2f", ceil(self.subTotalAmount*100)/100)
                                self.vatLabel.text = "AED " + String(format: "%.2f", ceil(self.vatamount*100)/100)
                            } else {
                               
                                cell.qtyLabel.isHidden = true
                            }
                        }
                    }
                }
            }
       
        cell.nameLabel.text = self.tableItems[indexPath.row].value(forKey: "item") as? String ?? ""
        return cell
    }
    
   
   
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductListCVCell else {
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
        return CGSize(width: width, height: 75)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

