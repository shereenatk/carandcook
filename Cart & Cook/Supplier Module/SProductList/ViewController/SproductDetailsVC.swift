//
//  SproductDetailsVC.swift
//  Cart & Cook
//
//  Created by Development  on 21/06/2021.
//

import Foundation
import UIKit
import BadgeControl
class SproductDetailsVC: UIViewController, UITextFieldDelegate {
    var sAddProductVM = SAddProductVM()
    var saddProductM : SAddProductM?
    var supplierId = 0
    var supplierName = ""
    
    @IBOutlet weak var noproductLabel: UILabel!
    @IBOutlet weak var addProducctBtn: PrimaryroundButton!
    @IBOutlet weak var productCV: UICollectionView!
    @IBOutlet weak var cartcountBtn: UIButton!
    private var upperLeftBadge: BadgeController!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
        getProductList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        upperLeftBadge = BadgeController(for: cartcountBtn, in: .upperRightCorner, badgeBackgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) , badgeTextColor: .white, borderWidth: 0, badgeHeight: 20)
        if let count = UserDefaults.standard.value(forKey: SUPPLIERCARTCOUNT) as? Int {
            upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

        } else {
            upperLeftBadge.addOrReplaceCurrent(with: String(0), animated: false)
        }
    }
    
    @IBAction func openCart(_ sender: Any) {
        if let vc =  UIStoryboard(name: "SupplierCart", bundle: nil).instantiateViewController(withIdentifier: "SupplierCartVC") as? SupplierCartVC {
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func productListMenuAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "SProductList", bundle: nil).instantiateViewController(withIdentifier: "SproductDetailsVC") as? SproductDetailsVC {
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func allsupplerMenuAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierHomeVC") as? SupplierHomeVC {
            UserDefaults.standard.setValue(0, forKey: SUPPLIERID)
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func supplierOrder(_ sender: Any) {
        if let vc =  UIStoryboard(name: "SupplierCart", bundle: nil).instantiateViewController(withIdentifier: "SupplierOrderListVC") as? SupplierOrderListVC {
            vc.supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
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
    
    fileprivate func getProductList() {
        let supplierID = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
        self.sAddProductVM.getProductList(supplierID: supplierID){  isSuccess, errorMessage  in
            self.activityIndicator.stopAnimating()
            if let count =  SAddProductVM.responseStatus?.count {
                if(count > 0) {
                    self.saddProductM = SAddProductVM.responseStatus
                 
                    self.productCV.reloadData()
                } else {
                    self.addProducctBtn.isHidden = false
                    self.noproductLabel.isHidden = false
                }
            }
        }
    }
    
}
extension  SproductDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.saddProductM?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  productCV.dequeueReusableCell(withReuseIdentifier: "SProductCC", for: indexPath) as? SProductCC else {
               return UICollectionViewCell()
          }
    let unint = self.saddProductM?[indexPath.row].unit  ?? ""
        let country = self.saddProductM?[indexPath.row].countryName ?? ""
        cell.countryLabel.text = country
        let actualprice = self.saddProductM?[indexPath.row].price ?? 0.0
        
                    cell.priceLabel.text = " AED " +  String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
                    var itemID = 0
                    itemID = self.saddProductM?[indexPath.row].productID ?? 0
                   
        if let cartCount = self.getSupplierCartCount(id: itemID) {
                            if(cartCount > 0) {
                               cell.subButton.isHidden = false
                                cell.qtyLabel.isHidden = false
                                cell.qtyLabel.text =  "\(cartCount)"
                                cell.total = Double(cartCount) * actualprice
                            } else {
                               
                                cell.qtyLabel.isHidden = true
                                cell.subButton.isHidden = true
                            }
            if let count = UserDefaults.standard.value(forKey: SUPPLIERCARTCOUNT) as? Int {
                upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

            }
                        }
           let name = self.saddProductM?[indexPath.row].productName ?? ""
        cell.nameLabel.text = name
  
        cell.addTapAction = { cell in
         var  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
            qty = qty + 1
            cell.subButton.isHidden = false
            cell.qtyLabel.isHidden = false
         cell.qtyLabel.text  = "\(qty)"
            self.updateSupplierCartCount(id: itemID, count: qty, price: actualprice, country: country , productName: name, unit: unint )
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
                
               }
      
            self.updateSupplierCartCount(id: itemID, count: qty,  price: actualprice, country: country , productName: name, unit: unint )
            if let count = UserDefaults.standard.value(forKey: SUPPLIERCARTCOUNT) as? Int {
                self.upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

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
        return CGSize(width: width, height: 90)
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

