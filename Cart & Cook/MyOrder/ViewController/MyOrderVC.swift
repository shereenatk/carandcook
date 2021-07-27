//
//  MyOrderVC.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation
import UIKit
import SideMenu

class MyOrderVC: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myOrderTV: UITableView!
    var orderListVM = MyOrderVM()
    var orderListM : MyOrderModel?
    
    
    @IBOutlet weak var emptyView: UIView!
    override func viewDidLoad() {
        myOrderTV.tableFooterView = UIView()
        self.setupSideMenu()
    }
    override func viewWillAppear(_ animated: Bool) {
        getMyOrderList()
    }
    private func getMyOrderList() {
        self.orderListVM.getMyOrderList(orderId: 0){ isSuccess, errorMessage  in
            self.orderListM = self.orderListVM.responseStatus
            if let count = self.orderListM?.count{
                if(count > 0) {
                    self.orderListM  = self.orderListM?.reversed()
                    self.myOrderTV.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.emptyView.isHidden = true
                } else {
                    self.activityIndicator.stopAnimating()
                    self.emptyView.isHidden = false
                }
            }
           
        }
    }
    
    @IBAction func shopNow(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 1
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    
    @IBAction func menuAction(_ sender: Any) {

                                  
          if let left = SideMenuManager.defaultManager.leftMenuNavigationController{
              
              present(left, animated: true, completion: nil)
          }
                           
    }
    @IBAction func searchProduct(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
}
extension MyOrderVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListM?.count ?? 0
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTVCell", for: indexPath) as? MyOrderTVCell else {
            return UITableViewCell()
        }
        if let id = self.orderListM?[indexPath.row].orderID {
            cell.orderIdLabel.text = "Order Id : #" +  "\(id)"
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
            // Dates used for the comparison
            let date1 = dateFormatter.date(from: time) ??  Date()
            let date2 = dateFormatter.date(from: nowMinusTwoAndAHalfHours.getFormattedDate(format: "MMM dd yyyy hh:mma")) ?? Date()
            if(date1 > date2) {
                cell.timerLabel.isHidden = false
                var diffInMinInt = Calendar.current.dateComponents([.minute], from: date2, to: date1).minute ?? 0
                var diffInMins = Double(diffInMinInt)
                cell.timerLabel.text = "Cancel in " + "\(diffInMinInt)" + " min"
              
                cell.timer = Timer.scheduledTimer(withTimeInterval:  60, repeats: true) { timer in
                    if diffInMinInt > 0 {
                        
                        diffInMinInt -= 1
                        cell.timerLabel.text = "Cancel in " + "\(diffInMinInt)" + " min"
                        
                    }
                    if(diffInMinInt == 0) {
                        diffInMinInt -= 1
                        cell.timer.invalidate()
                        cell.timerLabel.isHidden = true
                    }
                    
                    
                }
            } else {
                cell.timerLabel.isHidden = true
                
            }
        }
        let baseprice = self.orderListM?[indexPath.row].total ?? 0.0
        cell.baseAmountLabel.text = "AED " +  String(format: "%.2f", ceil(baseprice*100)/100)
        let vat = baseprice * 0.05
        let total = baseprice + vat
        cell.vatAmountLabel.text = "AED " + String(format: "%.2f", ceil(vat*100)/100)
          cell.totalAMountLabel.text = "AED " + String(format: "%.2f", ceil(total*100)/100)


        if let id = self.orderListM?[indexPath.row].orderID {
            cell.orderIdLabel.text = "Order Id : #" +  "\(id)"
        }
        cell.addressLabel.text =  self.orderListM?[indexPath.row].deliveryAddress ?? ""
        cell.phoneLabel.text =  self.orderListM?[indexPath.row].phoneNumber ?? ""
        if let status = self.orderListM?[indexPath.row].orderStatus {
            cell.statusLabel.text =  status
            switch status.lowercased() {
            case "pending" :
                cell.statusIMageView.tintColor = .gray
                cell.statusIMageView.image = UIImage(named: "order_pending")
            case "canceled" :
                cell.statusIMageView.tintColor = .red
                cell.statusIMageView.image = UIImage(named: "order_cancel")
                cell.timerLabel.isHidden = true
            case "delivered" :
                cell.statusIMageView.tintColor = AppColor.colorGreen.value
                cell.statusIMageView.image = UIImage(named: "order_complete")
                cell.timerLabel.isHidden = true
             default:
                cell.statusIMageView.tintColor = .gray
                cell.statusIMageView.image = UIImage(named: "order_pending")
            }
        }
        
        
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        
            return 180
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = myOrderTV.cellForRow(at: indexPath) as? MyOrderTVCell else {
           return
       }
        let id = cell.orderNum
        let storyboard = UIStoryboard(name: "OrderDetails", bundle: nil)
        if    let pvc = storyboard.instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsVC {
            pvc.orderNum = "\(cell.orderNum)"
            if let status = cell.statusLabel.text {
                pvc.status = status
            }
            if cell.timerLabel.isHidden {
                pvc.isCancelHidden = true
            } else {
                pvc.isCancelHidden = false
            }
            
            if let dateVal = cell.dateLabel.text {
                pvc.dateVal = dateVal
            }
            
            if let dateVal = cell.dateLabel.text {
                pvc.dateVal = dateVal
            }
            if let totalVal = cell.totalAMountLabel.text {
                pvc.toral = totalVal
            }
                pvc.modalPresentationStyle =
                    UIModalPresentationStyle.overCurrentContext
                self.present(pvc, animated: true, completion: nil)
        }
      
    
    
    }
    

    
}
