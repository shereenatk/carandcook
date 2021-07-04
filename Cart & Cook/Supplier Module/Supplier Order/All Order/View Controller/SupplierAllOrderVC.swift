//
//  SupplierAllOrderVC.swift
//  Cart & Cook
//
//  Created by Development  on 23/06/2021.
//

import Foundation
import UIKit
class SupplierAllOrderVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myOrderTV: UITableView!
    
    @IBOutlet weak var emptyView: UIView!
    var orderListVM = SupplierAllOrderViewModel()
    var orderListM : [SupplierAllOrder]?
    
    override func viewDidLoad() {
        getSupplierOrderList()
        myOrderTV.tableFooterView = UIView()
    }
    
    private func getSupplierOrderList() {
        self.orderListVM.getsupplierOrderList(supplierId: 0, orderId: 0){ isSuccess, errorMessage  in
            self.orderListM = self.orderListVM.responseStatus?.orders
            
            if let count = self.orderListM?.count {
                if(count > 0) {
                    self.orderListM =  self.orderListM?.reversed()
                    self.myOrderTV.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.emptyView.isHidden = true
                } else {
                    self.emptyView.isHidden = false
                }
            }
            
           
        }
    }
    @IBAction func homeMenuAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func supplierMenuAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierHomeVC") as? SupplierHomeVC {
            UserDefaults.standard.setValue(0, forKey: SUPPLIERID)
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    @IBAction func overViewAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "OverViewVC") as? OverViewVC {
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    @IBAction func orderMenuAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierAllOrderVC") as? SupplierAllOrderVC {
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    
}
extension SupplierAllOrderVC : UITableViewDelegate, UITableViewDataSource {
    
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
