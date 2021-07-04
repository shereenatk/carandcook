//
//  DetailedOrderVC.swift
//  Cart & Cook
//
//  Created by Development  on 06/06/2021.
//

import Foundation
import UIKit
class DetailedOrderVC: UIViewController {
    var orderListVM = MyOrderVM()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var orderListM : MyOrderModel?
    @IBOutlet weak var productCV: UICollectionView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var basePriceLabel: UILabel!
    var orderId = 0
    @IBOutlet weak var vatPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    override func viewDidLoad() {
        getMyOrderList()
        headingLabel.text = "Order No: #" + "\(orderId)"
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func getMyOrderList() {
     
        self.orderListVM.getMyOrderList(orderId: self.orderId){ isSuccess, errorMessage  in
                self.orderListM = self.orderListVM.responseStatus
                self.orderListM  = self.orderListM?.reversed()
            
            if let count = self.orderListM?[0].items?.count {
                self.tableHeight.constant = CGFloat(count * 70 ) + 30
            }
            let subtotal = self.orderListM?[0].total ?? 0.0
            let vat  = subtotal * 0.05
            let total = subtotal + vat
            self.basePriceLabel.text =  "AED " + String(format: "%.2f", ceil(subtotal*100)/100)
            self.vatPriceLabel.text =   "AED " + String(format: "%.2f", ceil(vat*100)/100)
            self.totalPriceLabel.text =   "AED " + String(format: "%.2f", ceil(total*100)/100)
            self.productCV.reloadData()
            self.activityIndicator.stopAnimating()
        }
        
    }
}
extension  DetailedOrderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orderListM?[0].items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  productCV.dequeueReusableCell(withReuseIdentifier: "ReviewCC", for: indexPath) as? ReviewCC else {
               return UICollectionViewCell()
          }
         let unint = self.orderListM?[0].items?[indexPath.row].unit ?? ""

            
           
            if let actualprice = self.orderListM?[0].items?[indexPath.row].price {
                    cell.priceLabel.text = "AED " +  String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
                    var itemID = 0
                itemID = self.orderListM?[0].items?[indexPath.row].itemID ?? 0
                cell.qtyLabel.isHidden = false
                let weight = self.orderListM?[0].items?[indexPath.row].weight ?? 0.0
                cell.qtyLabel.text = "Quantity: " + "\(weight)"
                let tota = Double(weight) * actualprice
                cell.totalLabel.text = "AED " + "\(tota)"
                    
                }
            
        
    
       
        cell.nameLabel.text = self.orderListM?[0].items?[indexPath.row].name ?? ""
        return cell
    
    }
    
   
   
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductListCVCell else {
                                       return
                                   }
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
            vc.itemId = cell.id
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

