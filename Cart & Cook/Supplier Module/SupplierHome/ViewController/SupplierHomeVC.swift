//
//  SupplierHomeVC.swift
//  Cart & Cook
//
//  Created by Development  on 21/06/2021.
//

import Foundation
import UIKit
class SupplierHomeVC: UIViewController {
    var supllierVM = SupplierViewModel()
    var supplierM: [SupplierListmodelElement]?
    let getobjectVM = GetObjectVM()
    @IBOutlet weak var supplierTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menubtn2: VerticalButton!{
        didSet{
            menubtn2.imageView?.contentMode = .scaleToFill
        }
    }
    override func viewDidLoad() {
        supplierTableView.tableFooterView = UIView()
        getSupplierList()
    }
    
    
    @IBAction func addNewsupplier(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "AddSupplierVC") as? AddSupplierVC {
            self.navigationController?.pushViewController(vc, animated:   true)
        }
    }
    
    private func getSupplierList() {
        self.supllierVM.getSupplierList(){  isSuccess, errorMessage  in
            self.activityIndicator.stopAnimating()
            if let count =  self.supllierVM.responseStatus?.count {
                if(count > 0) {
                    self.supplierM = self.supllierVM.responseStatus
                    self.supplierTableView.reloadData()
                }
            }
            self.supplierTableView.reloadData()
        }
    }
   
    
    @IBAction func homeMenuAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func supplierMenuAction(_ sender: Any) {
       
    }
    
    @IBAction func orderMenuAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierAllOrderVC") as? SupplierAllOrderVC {
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func overViewAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "OverViewVC") as? OverViewVC {
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
}
extension SupplierHomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.supplierM?.count ?? 0
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierTC", for: indexPath) as? SupplierTC else {
            return UITableViewCell()
        }
        cell.supplierID = self.supplierM?[indexPath.row].supplierID ?? 0
        cell.sNameLabel.text = self.supplierM?[indexPath.row].supplierName ?? ""
        cell.sLocationLabel.text = self.supplierM?[indexPath.row].address ?? ""
        if let logo =  self.supplierM?[indexPath.row].logo {
            if(logo != "") {
                let imageData =  self.getImage(path: logo)
                getobjectVM.getObjectData(fileNAme: logo) {  isSuccess, errorMessage  in
                    if let  byte = self.getobjectVM.responseStatus?.fileBytes {
                        var encoded64 = byte
                        let remainder = encoded64.count % 4
                        if remainder > 0 {
                            encoded64 = encoded64.padding(toLength: encoded64.count + 4 - remainder,
                                                          withPad: "=",
                                                          startingAt: 0)
                        }
                        let dataDecoded : Data = Data(base64Encoded: encoded64, options: .ignoreUnknownCharacters)!
                        let decodedimage = UIImage(data: dataDecoded, scale: 0.5)

                        cell.sProfilePic.image = decodedimage
                    }
                   
                }
              
               
                
            }
         
        }
        cell.viewBtn.tag = indexPath.row
        cell.viewBtn.addTarget(self, action: #selector(viewSupplier(_:)), for: .touchUpInside)
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        
            return 75
        
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SupplierTC
        if let vc =  UIStoryboard(name: "SProductList", bundle: nil).instantiateViewController(withIdentifier: "SproductDetailsVC") as? SproductDetailsVC {
            vc.supplierId = cell.supplierID
            UserDefaults.standard.setValue(cell.supplierID, forKey: SUPPLIERID)
            self.navigationController?.pushViewController(vc, animated:   true)

        }
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let cell = tableView.cellForRow(at: indexPath) as! SupplierTC
            
            let reassign = UIContextualAction(style: .destructive, title: "Edit") { (action, view, completion) in
                if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "AddSupplierVC") as? AddSupplierVC {
                    vc.supplierId = cell.supplierID
                    
                    vc.fromVc = "edit"
                    vc.supplierDetails = self.supplierM?[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated:   true)

                }
                
             
                completion(true)
               }

            reassign.backgroundColor = AppColor.colorGreen.value
            return UISwipeActionsConfiguration(actions: [reassign])
    
        
        }
    
    @objc func viewSupplier(_ sender:UIButton)
    {

        let indexPath = IndexPath(row: sender.tag, section: 0)
       if let cell = supplierTableView.cellForRow(at: indexPath) as? SupplierTC {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "AddSupplierVC") as? AddSupplierVC {
            vc.supplierId = cell.supplierID
            
            vc.fromVc = "view"
            vc.supplierDetails = self.supplierM?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated:   true)

        }
       }
    }
}
