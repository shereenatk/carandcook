//
//  SupplierCartVC.swift
//  Cart & Cook
//
//  Created by Development  on 28/06/2021.
//

import Foundation
import UIKit
import BadgeControl
import CoreData
class SupplierCartVC: UIViewController {
    var supplierName = ""
    @IBOutlet weak var vatEditView: UIView!
    var tableItems: [NSManagedObject] = []
    var totalamount = 0.0
    var subTotalAmount = 0.0
    var vatamount = 0.0
    var placeOrderVM = SupplierPalceOrderVM()
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var vatEditTF: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!{
        didSet{
            cancelBtn.layer.cornerRadius = 15
            cancelBtn.layer.borderColor = AppColor.colorGreen.value.cgColor
            cancelBtn.layer.borderWidth = 1
            cancelBtn.clipsToBounds = true
        }
    }
    @IBOutlet weak var emotyView: UIView!
    @IBOutlet weak var productCV: UICollectionView!
    @IBOutlet weak var cartcountBtn: UIButton!
    private var upperLeftBadge: BadgeController!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    override func viewDidLoad() {
        getcartList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        upperLeftBadge = BadgeController(for: cartcountBtn, in: .upperRightCorner, badgeBackgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) , badgeTextColor: .white, borderWidth: 0, badgeHeight: 20)
        if let count = UserDefaults.standard.value(forKey: SUPPLIERCARTCOUNT) as? Int {
            upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

        } else {
            upperLeftBadge.addOrReplaceCurrent(with: String(0), animated: false)
        }
    }
    
    private func getcartList() {
       
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "SupplierCart")
        do {
            fetchRequest.predicate = NSPredicate(format: "supplierId = %@", "\(supplierId)")
           tableItems = try managedContext.fetch(fetchRequest)
            if(tableItems.count <= 0) {
                emotyView.isHidden = false
            }
            self.activityIndicator.stopAnimating()
            productCV.reloadData()
           
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func editVatAction(_ sender: Any) {
        backgroundView.isHidden = false
        vatEditView.isHidden = false
    }
    @IBAction func vatCancelAction(_ sender: Any) {
        backgroundView.isHidden = true
        vatEditView.isHidden = true
    }
    fileprivate func clearCartCurrentSupplier() {
        let managedContext =  appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "SupplierCart")
        do {
            fetchRequest.predicate = NSPredicate(format: "supplierId = %@", "\(supplierId)")
           tableItems = try managedContext.fetch(fetchRequest)
            print(tableItems.count)
            for item in tableItems {
                managedContext.delete(item)
                try managedContext.save()
                self.emotyView.isHidden = false
                upperLeftBadge.addOrReplaceCurrent(with: "0", animated: false)
                UserDefaults.standard.setValue(0, forKey: SUPPLIERCARTCOUNT)
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    @IBAction func clearCart(_ sender: Any) {
        clearCartCurrentSupplier()
    }
    @IBAction func orderBtnAction(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm Order", message: "Are you sure, You want to place the order ?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "CONFIRM", style: .default, handler: {_ in
            self.placeOrder()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    private func placeOrder() {
        self.activityIndicator.startAnimating()
        var orders: [[String: Any]] = [[String: Any]]()
        for item in tableItems {
            let price = item.value(forKey: "price") as? Double ?? 0.0
            let cartCount = item.value(forKey: "cartCount") as? Int ?? 0
           let  itemID = item.value(forKey: "itemID") as? Int ?? 0
            let item =   [
                "ItemId": item.value(forKey: "itemID") as? Int ?? 0,
                "Weight":  cartCount,
                "Price": price,
                "Unit":  item.value(forKey: "unit") as? String   ?? ""
            ] as [String : Any]
            orders.append(item)
        }
    print(orders)
        
        let totalamount = self.totalLabel.text ?? ""
        let subTotal = self.subTotalLabel.text ?? ""
        let subtotalVal = subTotal.replacingOccurrences(of: "AED ", with: "", options: [.caseInsensitive, .regularExpression])
        let totalVal = totalamount.replacingOccurrences(of: "AED ", with: "", options: [.caseInsensitive, .regularExpression])


        let paramDict =  [
            "Items": orders,
            "CustomerId" : UserDefaults.standard.value(forKey: USERID) as? Int ?? 0 ,
            "RestaurantId": UserDefaults.standard.value(forKey: RESTAURANTID) as? Int ?? 0 ,
            "Total": subtotalVal,
            "OrderId" : 0,
            "IncludedVatAmount" : totalVal,
            "VatAmount" : self.vatamount,
            "SupplierID": UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
        ] as [String : Any]
     

        self.placeOrderVM.placeOrder(paramDict: paramDict){  isSuccess, errorMessage  in
//print("aaa", paramDict)
            if let success = self.placeOrderVM.responseStatus?.message?.lowercased() {
                let date = Date()
                let calendar = Calendar.current
                let components = calendar.dateComponents([.weekday], from: date)
                let dayOfWeek = components.weekday
                    if(success == "success"){
                        self.activityIndicator.stopAnimating()
                        self.clearCartCurrentSupplier()
                        UserDefaults.standard.setValue(0, forKey: SUPPLIERCARTCOUNT)
                        if let vc =  UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "ThnakyouVC") as? ThnakyouVC {
                            vc.fromVc = "supplier"
                            self.navigationController?.pushViewController(vc, animated:   true)
                        }
                    }
                    else {
                        self.showMessageAlert(message: "Somthing went wrong.. Please try again later")
                }
            }
        }
    }
    @IBAction func supplierOrder(_ sender: Any) {
        if let vc =  UIStoryboard(name: "SupplierCart", bundle: nil).instantiateViewController(withIdentifier: "SupplierOrderListVC") as? SupplierOrderListVC {
            vc.supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func productListMenuBtn(_ sender: Any) {
        if let vc =  UIStoryboard(name: "SProductList", bundle: nil).instantiateViewController(withIdentifier: "SproductDetailsVC") as? SproductDetailsVC {
           
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func addProductToCart(_ sender: Any) {
        if let vc =  UIStoryboard(name: "SProductList", bundle: nil).instantiateViewController(withIdentifier: "SproductDetailsVC") as? SproductDetailsVC {
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    @IBAction func vateditOkACtion(_ sender: Any) {
        backgroundView.isHidden = true
        vatEditView.isHidden = true
        if let newVat = self.vatEditTF.text {
            self.vatamount = Double(newVat) ?? 0.0
            self.totalamount =    self.subTotalAmount + self.vatamount
        }
    }
    
    @IBAction func allsupplerMenuAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierHomeVC") as? SupplierHomeVC {
            UserDefaults.standard.setValue(0, forKey: SUPPLIERID)
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addProductAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "SProductList", bundle: nil).instantiateViewController(withIdentifier: "SAddProductVC") as? SAddProductVC {
            vc.supplierId = self.supplierId
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    private func updateTotalAmount(qty : Int)  {
         totalamount = 0.0
         subTotalAmount = 0.0
        if(tableItems.count > 0) {
            for i in 0...tableItems.count - 1  {
                let price = self.tableItems[i].value(forKey: "price") as? Double ?? 0.0
            
                self.subTotalAmount = self.subTotalAmount + (Double(qty) * price)
                self.totalamount =    self.subTotalAmount + self.vatamount
                self.totalLabel.text = "AED " +  String(format: "%.2f", ceil(self.totalamount*100)/100)
                self.subTotalLabel.text = "AED " +  String(format: "%.2f", ceil(self.subTotalAmount*100)/100)
                self.vatLabel.text = "AED " + String(format: "%.2f", ceil(self.vatamount*100)/100)
                }
            
        }


    }
    

}
extension  SupplierCartVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  productCV.dequeueReusableCell(withReuseIdentifier: "SProductCC", for: indexPath) as? SProductCC else {
               return UICollectionViewCell()
          }
        let unint = self.tableItems[indexPath.row].value(forKey: "unit") as? String ?? ""
        let country = self.tableItems[indexPath.row].value(forKey: "country") as? String ?? ""
        cell.countryLabel.text = country
        let actualprice = self.tableItems[indexPath.row].value(forKey: "price") as? Double ?? 0.0
        cell.priceLabel.text = " AED " +  String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
        
//        let total = self.tableItems[indexPath.row].value(forKey: "total") as? Double ?? 0.0
//        cell.totalLabel.text = "Total : AED " +  String(format: "%.2f", ceil(total*100)/100)
        
        let itemID =  self.tableItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
        if let cartCount = self.getSupplierCartCount(id: itemID) {
            if(cartCount > 0) {
               cell.subButton.isHidden = false
                cell.qtyLabel.isHidden = false
                cell.qtyLabel.text =  "\(cartCount)"
               let total = Double(cartCount) * actualprice
                cell.totalLabel.text = "Total : AED " +  String(format: "%.2f", ceil(total*100)/100)
            } else {
               
                cell.qtyLabel.isHidden = true
                cell.subButton.isHidden = true
            }
            if let count = UserDefaults.standard.value(forKey: SUPPLIERCARTCOUNT) as? Int {
                upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

            }
            self.updateTotalAmount(qty: cartCount)
                        }
           let name = self.tableItems[indexPath.row].value(forKey: "productName") as? String ?? ""
        cell.nameLabel.text = name
  
        cell.addTapAction = { cell in
         var  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
            qty = qty + 1
            cell.subButton.isHidden = false
            cell.qtyLabel.isHidden = false
         cell.qtyLabel.text  = "\(qty)"
            let total = Double(qty) * actualprice
            cell.totalLabel.text = "Total : AED " +  String(format: "%.2f", ceil(total*100)/100)
            self.updateSupplierCartCount(id: itemID, count: qty, price: actualprice, country: country , productName: name, unit: unint )
            self.updateTotalAmount(qty: qty)
            if let count = UserDefaults.standard.value(forKey: SUPPLIERCARTCOUNT) as? Int {
                self.upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

            }
        }
        cell.qtyLabel.delegate = self
        cell.qtyLabel.tag = itemID
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
                self.productCV.reloadData()
               }
            let total = Double(qty) * actualprice
            cell.totalLabel.text = "Total : AED " +  String(format: "%.2f", ceil(total*100)/100)
            self.updateSupplierCartCount(id: itemID, count: qty, price: actualprice, country: country , productName: name, unit: unint )
            self.updateTotalAmount(qty: qty)
            if let count = UserDefaults.standard.value(forKey: SUPPLIERCARTCOUNT) as? Int {
                self.upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)
                if(count == 0) {
                    self.emotyView.isHidden = false
                } else {
                    self.emotyView.isHidden = true
                }
            }
                  }
        cell.deleteTapAction = { cell in
              
                self.tableItems.remove(at: indexPath.row)
            if(self.tableItems.count == 0) {
                self.emotyView.isHidden = false
            } else {
                self.emotyView.isHidden = true
            }
                self.productCV.reloadData()
             
            self.updateSupplierCartCount(id: itemID, count: 0, price: actualprice, country: country , productName: name, unit: unint )
            self.updateTotalAmount(qty: 0)
        }
        
        
       
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductListCVCell else {
//                                       return
//                                   }
//        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
//            vc.itemId = cell.id
//            self.navigationController?.pushViewController(vc, animated:   true)
//
//        }
//       }
    
    
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
        return CGSize(width: width, height: 110)
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

extension SupplierCartVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let count = textField.text {
            let cpountInt = Int(count) ?? 0
            self.updateTotalAmount(qty: cpountInt)
        }
    }
}
