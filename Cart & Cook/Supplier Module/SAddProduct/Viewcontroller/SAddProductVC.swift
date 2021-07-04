//
//  SAddProductVC.swift
//  Cart & Cook
//
//  Created by Development  on 21/06/2021.
//

import Foundation
import UIKit
class SAddProductVC: UIViewController {
    var supplierId = 0
    var sAddProductVM = SAddProductVM()
    var saddProductM : SAddProductM?
    var mapProductVM = MapProductVM()
    static var categoryList: [String] = []
    var shouldCellBeExpanded: [Bool] = []
    var selectedProductId  = ""
    @IBOutlet weak var cancelBtn: UIButton!{
        didSet{
            cancelBtn.layer.cornerRadius = 15
            cancelBtn.layer.borderColor = AppColor.colorGreen.value.cgColor
            cancelBtn.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var productTV: UITableView!
    override func viewDidLoad() {
        SAddProductVC.categoryList = []
       getCategoryList()
        productTV.tableFooterView = UIView()
    }
    fileprivate func getCategoryList() {
        self.sAddProductVM.getProductList(supplierID: 0){  isSuccess, errorMessage  in
            if let count =  SAddProductVM.responseStatus?.count {
                if(count > 0) {
                    self.saddProductM = SAddProductVM.responseStatus
                    if let itemList = self.saddProductM {
                        for item in itemList {
                            let type = item.typeName ?? ""
                            if(!SAddProductVC.categoryList.contains(type)) {
                                SAddProductVC.categoryList.append(type)
                                self.shouldCellBeExpanded.append(false)
                            }
                        }
                    }
                    self.productTV.reloadData()
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func expandButtonAction(button:UIButton) {
         if shouldCellBeExpanded[button.tag] {
            shouldCellBeExpanded[button.tag] = false
            self.productTV.beginUpdates()
            self.productTV.endUpdates()

            button.setTitle("▼", for: .normal)
         }
         else {
            shouldCellBeExpanded[button.tag] = true
            self.productTV.beginUpdates()
            self.productTV.endUpdates()
            button.setTitle("▲", for: .normal)
         }
     }
    
    @IBAction func saveProductsAction(_ sender: Any) {
        
        for i in 0...SAddProductVC.categoryList.count - 1 {
            let myIndexPath = IndexPath(row: i, section: 0)
            let cell = productTV.cellForRow(at: myIndexPath) as! AddProductTC
            if(cell.isAddSelected.count > 0) {
                for j in 0...cell.isAddSelected.count - 1 {
                    if(cell.isAddSelected[j]) {
                        let id = cell.productIdList[j]
                        self.selectedProductId =  self.selectedProductId + "\(id)" + ","
                    }
                }
            }
            
        }
        
        self.mapProductVM.mapProducts(productId: self.selectedProductId, supplierId: self.supplierId){  isSuccess, errorMessage  in
            if let message =   self.mapProductVM.responseStatus?.message {
                if let vc =  UIStoryboard(name: "SProductList", bundle: nil).instantiateViewController(withIdentifier: "SproductDetailsVC") as? SproductDetailsVC {
                    vc.supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
                    self.navigationController?.pushViewController(vc, animated:   true)

                }
            }
        }
    }
    
}
 
extension SAddProductVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductTC", for: indexPath) as? AddProductTC else {
            return UITableViewCell()
        }
        cell.catNameLabel.text = "Category : " + SAddProductVC.categoryList[indexPath.row]
        cell.subListBtn.tag = indexPath.row
        cell.subListBtn.addTarget(self, action: #selector(expandButtonAction), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SAddProductVC.categoryList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.shouldCellBeExpanded[indexPath.row]  {
                var productList : [String] = []
                var countryList : [String] = []
                let type = SAddProductVC.categoryList[indexPath.row]
                if let itemList = SAddProductVM.responseStatus {
                    for item in itemList {
                        let pdcttype = item.typeName ?? ""
                        if(type == pdcttype) {
                            let prdctNAme = item.productName ?? ""
                            let origin = item.countryName ?? ""
                            if(!productList.contains(prdctNAme)){
                                productList.append(prdctNAme)
                                countryList.append(origin)
                            }
                        }
                    }
                }
                if(productList.count > 0) {
                    return CGFloat(100 * productList.count) + 20
                } else {
                    return 50
                }
        } else {
            return 50
        }
      
       
       
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(self.isConnectedToInternet()){
//            let cell = tableView.cellForRow(at: indexPath) as! SubMailTC
//            let idVal = cell.id
//            let userInfo = [ "id" : idVal ]
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "submailListClicked"), object: nil, userInfo: userInfo)
//        }
    }

    

}
