//
//  SupplierEditOrderVC.swift
//  Cart & Cook
//
//  Created by Development  on 29/06/2021.
//

import Foundation
import UIKit
class SupplierEditOrderVC: UIViewController  {
    var supplierName = ""
    @IBOutlet weak var vatEditView: UIView!
    var totalamount = 0.0
    var subTotalAmount = 0.0
    var vatamount = 0.0
    var placeOrderVM = SupplierPalceOrderVM()
    var orderItemListM : [SupplierAllItem]!
    var orderDeyailsM : SupplierAllOrder?
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
    @IBOutlet weak var productCV: UICollectionView!
    
    @IBOutlet weak var updateBtn: PrimaryroundButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    let supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
   
    var orderId = 0
    override func viewDidLoad() {
        productCV.reloadData()
        if(orderId == 0) {
            titleLabel.text = "Place Order"
            updateBtn.setTitle("Order", for: .normal)
        } else {
            titleLabel.text = "Edit Order"
             updateBtn.setTitle("Update Order", for: .normal)
        }
        
        vatamount = orderDeyailsM?.vatAmount ?? 0.0
        
    }
  
    
    @IBAction func editVatAction(_ sender: Any) {
        backgroundView.isHidden = false
        vatEditView.isHidden = false
    }
    @IBAction func vatCancelAction(_ sender: Any) {
        backgroundView.isHidden = true
        vatEditView.isHidden = true
    }
  
    @IBAction func clearCart(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func orderBtnAction(_ sender: Any) {
        var mesage = ""
        var title = ""
        if(orderId == 0) {
            mesage = "Are you sure, You want to place the order ?"
            title = "Confirm Order"
        } else {
            mesage =  "Are you sure, You want to update the order ?"
            title = "Save Order"
        }
        
        let alert = UIAlertController(title: title, message: mesage, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {_ in
            self.placeOrder()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        

        self.present(alert, animated: true)
    }
    
    private func placeOrder() {
        var orders: [[String: Any]] = [[String: Any]]()
        for i in 0...self.orderItemListM.count - 1 {
            let indexPath = IndexPath(row: i, section: 0)
            guard let cell = productCV.cellForItem(at: indexPath) as? SProductCC else {
               return
           }
            let cartCountString = cell.qtyLabel.text ?? "0"
            let cartCount = Int(cartCountString) ?? 0
            let item =   [
                "ItemId": self.orderItemListM?[i].itemID ?? 0,
                "Weight":  cartCount,
                "Price": self.orderItemListM?[i].price ?? 0.0,
                "Unit": self.orderItemListM?[i].unit ?? ""
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
            "OrderId" : self.orderId,
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
                        if let supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int {
                            if(supplierId == 0) {
                                if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierAllOrderVC") as? SupplierAllOrderVC {
                                 
                                    self.navigationController?.pushViewController(vc, animated:   true)
                                }
                            } else {
                                if let vc =  UIStoryboard(name: "SupplierCart", bundle: nil).instantiateViewController(withIdentifier: "SupplierOrderListVC") as? SupplierOrderListVC {
                                 
                                    self.navigationController?.pushViewController(vc, animated:   true)
                                }
                            }
                        }
                       
                        
                    }
                    else {
                        self.showMessageAlert(message: "Somthing went wrong.. Please try again later")
                }
            }
        }
    }
    
    @IBAction func vateditOkACtion(_ sender: Any) {
        backgroundView.isHidden = true
        vatEditView.isHidden = true
        if let newVat = self.vatEditTF.text {
            self.vatamount = Double(newVat) ?? 0.0
           
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func updateTotalAmount(qty: Int)  {
         totalamount = 0.0
         subTotalAmount = 0.0
        for item in self.orderItemListM {
            
                let price = item.price ?? 0.0
            
                self.subTotalAmount = self.subTotalAmount + (Double(qty) * price)
                self.totalamount =    self.subTotalAmount + self.vatamount
                self.totalLabel.text = "AED " +  String(format: "%.2f", ceil(self.totalamount*100)/100)
                self.subTotalLabel.text = "AED " +  String(format: "%.2f", ceil(self.subTotalAmount*100)/100)
                self.vatLabel.text = "AED " + String(format: "%.2f", ceil(self.vatamount*100)/100)
            
            }
       

    }
}
extension  SupplierEditOrderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderItemListM.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  productCV.dequeueReusableCell(withReuseIdentifier: "SProductCC", for: indexPath) as? SProductCC else {
               return UICollectionViewCell()
          }
        let unint = orderItemListM[indexPath.row].unit ?? ""
        let actualprice = orderItemListM[indexPath.row].price ?? 0.0
        cell.priceLabel.text = " AED " +  String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
        
        let itemID =  orderItemListM[indexPath.row].itemID ?? 0
        if let cartCountVal = orderItemListM[indexPath.row].weight {
            let cartCount = Int(cartCountVal)
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
            self.updateTotalAmount(qty: cartCount)
        }
           let name = orderItemListM[indexPath.row].productName ?? ""
        cell.nameLabel.text = name
  
        cell.addTapAction = { cell in
         var  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
            qty = qty + 1
            cell.subButton.isHidden = false
            cell.qtyLabel.isHidden = false
         cell.qtyLabel.text  = "\(qty)"
            let total = Double(qty) * actualprice
            cell.totalLabel.text = "Total : AED " +  String(format: "%.2f", ceil(total*100)/100)
            self.updateTotalAmount(qty: qty)
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
                if(self.orderItemListM.count > 1) {
                    self.orderItemListM.remove(at: indexPath.row)
               
                    self.productCV.reloadData()
                 
                    self.updateTotalAmount(qty: qty)
                }
                    
               }
            let total = Double(qty) * actualprice
            cell.totalLabel.text = "Total : AED " +  String(format: "%.2f", ceil(total*100)/100)
            self.updateTotalAmount(qty: qty)
          
    }
        cell.deleteTapAction = { cell in
            if(self.orderItemListM.count > 1) {
                self.orderItemListM.remove(at: indexPath.row)
           
                self.productCV.reloadData()
             
                self.updateTotalAmount(qty: 0)
            }
                
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

extension SupplierEditOrderVC : UITextFieldDelegate {
    
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
