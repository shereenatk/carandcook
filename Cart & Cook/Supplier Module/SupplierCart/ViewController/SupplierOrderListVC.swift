//
//  SupplierOrderListVC.swift
//  Cart & Cook
//
//  Created by Development  on 29/06/2021.
//

import Foundation
import UIKit
import BadgeControl
class SupplierOrderListVC: UIViewController {
    var supplierId = 0
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myOrderTV: UITableView!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var orderListVM = SupplierAllOrderViewModel()
    var orderListM : [SupplierAllOrder]?
    private var upperLeftBadge: BadgeController!
    override func viewDidLoad() {
        supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
        myOrderTV.tableFooterView = UIView()
        getSupplierOrderList()
        upperLeftBadge = BadgeController(for: cartcountBtn, in: .upperRightCorner, badgeBackgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) , badgeTextColor: .white, borderWidth: 0, badgeHeight: 20)
        if let count = UserDefaults.standard.value(forKey: SUPPLIERCARTCOUNT) as? Int {
            upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

        } else {
            upperLeftBadge.addOrReplaceCurrent(with: String(0), animated: false)
        }
    }
    @IBOutlet weak var cartcountBtn: UIButton!
    private func getSupplierOrderList() {
        self.orderListVM.getsupplierOrderList(supplierId: self.supplierId, orderId: 0){ isSuccess, errorMessage  in
            self.orderListM = self.orderListVM.responseStatus?.orders
            self.orderListM =  self.orderListM?.reversed()
            if let count = self.orderListM?.count {
                if( count > 0) {
                    if let name = self.orderListM?[0].supplierName {
                        self.titleLabel.text  = name + " - " + "Orders"
                    }
                    self.myOrderTV.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.emptyView.isHidden = true
                } else {
                    self.emptyView.isHidden = false
                }
            }
            
           
        }
    }
    
    @IBAction func addProductToCart(_ sender: Any) {
        if let vc =  UIStoryboard(name: "SProductList", bundle: nil).instantiateViewController(withIdentifier: "SproductDetailsVC") as? SproductDetailsVC {
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    @IBAction func allsupplerMenuAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierHomeVC") as? SupplierHomeVC {
            UserDefaults.standard.setValue(0, forKey: SUPPLIERID)
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func productListMenuAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "SProductList", bundle: nil).instantiateViewController(withIdentifier: "SproductDetailsVC") as? SproductDetailsVC {
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    
    @IBAction func openCart(_ sender: Any) {
        if let vc =  UIStoryboard(name: "SupplierCart", bundle: nil).instantiateViewController(withIdentifier: "SupplierCartVC") as? SupplierCartVC {
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
}
extension SupplierOrderListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListM?.count ?? 0
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SAllOrderTVCell", for: indexPath) as? SAllOrderTVCell else {
            return UITableViewCell()
        }
        if let id = self.orderListM?[indexPath.row].orderID {
            cell.orderIdLabel.text = "Order Id : #" +  "\(id)"
        }
        if let supid = self.orderListM?[indexPath.row].supplierID {
            cell.supplierId = supid
        }
        if let time = self.orderListM?[indexPath.row].orderDate {
            cell.orderNum = self.orderListM?[indexPath.row].orderID ?? 0
            cell.dateLabel.text = time
            let now = Date()
            let nowMinusTwoAndAHalfHours = now - 1*60*60
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd yyyy hh:mma"
                formatter.timeZone = TimeZone.current
                return formatter
            } ()
          
        }
        cell.sNameLabel.text = self.orderListM?[indexPath.row].supplierName ?? ""
        if let baseprice = self.orderListM?[indexPath.row].excludedVatAmount {
            cell.subTotalLabe.text = "AED " +  String(format: "%.2f", ceil(baseprice*100)/100)
        }
        if let vat = self.orderListM?[indexPath.row].vatAmount {
            cell.vatLabel.text = "AED " +  String(format: "%.2f", ceil(vat*100)/100)
        }
        if let total = self.orderListM?[indexPath.row].includedVatAmount {
            cell.totalLabel.text = "AED " + String(format: "%.2f", ceil(total*100)/100)
        }
        

        if let id = self.orderListM?[indexPath.row].orderID {
            cell.orderIdLabel.text = "Order Id : #" +  "\(id)"
        }
    
        if let status = self.orderListM?[indexPath.row].orderStatus {
            cell.statusLabel.text =  status
            switch status.lowercased() {
            case "pending" :
                cell.statusIMageView.tintColor = .gray
                cell.statusIMageView.image = UIImage(named: "order_pending")
            case "canceled" :
                cell.statusIMageView.tintColor = .red
                cell.statusIMageView.image = UIImage(named: "order_cancel")
            
            case "delivered" :
                cell.statusIMageView.tintColor = AppColor.colorGreen.value
                cell.statusIMageView.image = UIImage(named: "order_complete")
               
             default:
                cell.statusIMageView.tintColor = .gray
                cell.statusIMageView.image = UIImage(named: "order_pending")
            }
        }
        
        
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        
            return 150
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = myOrderTV.cellForRow(at: indexPath) as? SAllOrderTVCell else {
           return
       }
        let id = cell.orderNum
        let storyboard = UIStoryboard(name: "Supplier", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "SAllOrderDetailsVC") as! SAllOrderDetailsVC
        pvc.orderNum = cell.orderNum
        pvc.orderDetailsM = self.orderListM?[indexPath.row]
        if let item = self.orderListM?[indexPath.row].items {
            pvc.orderListM = item
            
        }
      
        if let status = cell.statusLabel.text {
            pvc.status = status
        }
    
        
        if let dateVal = cell.dateLabel.text {
            pvc.dateVal = dateVal
        }
        
        if let dateVal = cell.dateLabel.text {
            pvc.dateVal = dateVal
        }
        if let totalVal = cell.totalLabel.text {
            pvc.toral = totalVal
        }
        pvc.supplierId = cell.supplierId
//        print(cell.supplierId)
            pvc.modalPresentationStyle =
                UIModalPresentationStyle.overCurrentContext
            self.present(pvc, animated: true, completion: nil)
    
    
    }
    

    
}
