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
    var expandedSections : [Int] = []
    static var categoryList: [String] = []
    var shouldCellBeExpanded: [Bool] = []
    var selectedProductId  = ""
    var productIdList : [Int] = []
    var selectedIdList : [Int] = []
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var cancelBtn: UIButton!{
        didSet{
            cancelBtn.layer.cornerRadius = 15
            cancelBtn.layer.borderColor = AppColor.colorGreen.value.cgColor
            cancelBtn.layer.borderWidth = 1
        }
    }
    
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
                    self.categoryCV.reloadData()
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func expandButtonAction(button:UIButton) {
//        print(button.tag)
//         if shouldCellBeExpanded[button.tag] {
//            shouldCellBeExpanded[button.tag] = false
//            self.productTV.beginUpdates()
//            self.productTV.endUpdates()
//
//            button.setTitle("▼", for: .normal)
//         }
//         else {
//            shouldCellBeExpanded[button.tag] = true
//            self.productTV.beginUpdates()
//            self.productTV.endUpdates()
//            button.setTitle("▲", for: .normal)
//         }
        
        if self.expandedSections.contains(button.tag) {
          
            for i in 0...self.expandedSections.count - 1 {
                if(self.expandedSections[i] == button.tag) {
                    self.expandedSections.remove(at: i)
                }
                
            }
            button.setTitle("▲", for: .normal)
           
            }
            else {
                self.expandedSections.append(button.tag)
                button.setTitle("▼", for: .normal)
               
            }
        self.categoryCV.reloadSections(IndexSet(integer: button.tag))
//        (NSIndexSet(index: button.tag) as IndexSet)
     }
    
    @IBAction func saveProductsAction(_ sender: Any) {
        for value in selectedIdList {
            self.selectedProductId  = self.selectedProductId + "\(value)" + ","
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
 
extension SAddProductVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return SAddProductVC.categoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.expandedSections.contains(section) {
            var productList : [String] = []
            var countryList : [String] = []
            let type = SAddProductVC.categoryList[section]
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
                
//                print(isAddSelected)
             }
            return productList.count
            }
            else {
                return 0
            }
        
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  categoryCV.dequeueReusableCell(withReuseIdentifier: "AddProductCC", for: indexPath) as? AddProductCC else {
              return UICollectionViewCell()
         }
//        cell.catNameLabel.text = "Category : " + SAddProductVC.categoryList[indexPath.section]
        var productList : [String] = []
        var countryList : [String] = []
        var idList : [Int] = []
        let type = SAddProductVC.categoryList[indexPath.section]
        if let itemList = SAddProductVM.responseStatus {
            for item in itemList {
                let pdcttype = item.typeName ?? ""
                if(type == pdcttype) {
                    let prdctNAme = item.productName ?? ""
                    let origin = item.countryName ?? ""
                    let id = item.productID ?? 0
                    if(!productList.contains(prdctNAme)){
                        productList.append(prdctNAme)
                        idList.append(id)
                        countryList.append(origin)
                        
                    }
                }
            }
        }
        cell.catNameLabel.text = productList[indexPath.row]
        cell.countryLabel.text = countryList[indexPath.row]
        cell.addbtn.superview?.tag = indexPath.section
        cell.productId = idList[indexPath.row]
        
        
        if(selectedIdList.count > 0) {
            for i in 0...selectedIdList.count - 1  {
                if(selectedIdList[i] == idList[indexPath.row]) {
                  
                    cell.addbtn.setTitleColor(AppColor.colorGreen.value, for: .normal)
                    cell.addbtn.tintColor = AppColor.colorGreen.value
                    cell.addbtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    cell.addbtn.setTitle("ADDED", for: .normal)
                   
                }
               
            }
        }
        
       
        if(!selectedIdList.contains(idList[indexPath.row])) {
            cell.addbtn.setTitleColor(AppColor.colorPrimary.value, for: .normal)
            cell.addbtn.tintColor = AppColor.colorPrimary.value
            cell.addbtn.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.addbtn.setTitle("ADD", for: .normal)
        }
        
        
        
        
        cell.addbtn.tag = indexPath.row
        cell.addbtn.addTarget(self, action: #selector(adddButtonAction), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeaderCC", for: indexPath) as? sectionHeaderCC {
            sectionHeader.sectionHeaderlabel.text = "Category : " + SAddProductVC.categoryList[indexPath.section]
            sectionHeader.subListBrn.tag = indexPath.section
            sectionHeader.subListBrn.addTarget(self, action: #selector(expandButtonAction), for: .touchUpInside)
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20)
        
        return CGSize(width: width, height: 60)
        
    }
    @objc func adddButtonAction(button:UIButton) {
        let indexPath = IndexPath(row: button.tag, section: button.superview!.tag)
//        let cell = cv.cellForRow(at: myIndexPath) as! AddSubProductTC
        let cell = categoryCV.cellForItem(at: indexPath) as! AddProductCC
       
        let id = cell.productId
        if(selectedIdList.count > 0) {
            for i in 0...selectedIdList.count - 1  {
                if(selectedIdList[i] == id) {
                    selectedIdList.remove(at: i)
                }
               
            }
        }
        
       
        if(!selectedIdList.contains(id)) {
            selectedIdList.append(id)
//            self.selectedProductId  = self.selectedProductId + "\(cell.productId)" + ","
        }
        
        
        self.categoryCV.reloadData()
//        for (key, value) in isAddSelected {
//            print("\(key) : \(value)")
//            if(key == button.superview!.tag) {
//                if(value[button.tag]) {
//                    isAddSelected[button.superview!.tag]![button.tag] = false
//                    cell.addbtn.setTitleColor(AppColor.colorPrimary.value, for: .normal)
//                    cell.addbtn.tintColor = AppColor.colorPrimary.value
//                    cell.addbtn.setImage(UIImage(systemName: "plus"), for: .normal)
//                    cell.addbtn.setTitle("ADD", for: .normal)
//                } else {
//                    isAddSelected[button.superview!.tag]![button.tag] = true
//                    cell.addbtn.setTitleColor(AppColor.colorGreen.value, for: .normal)
//                    cell.addbtn.tintColor = AppColor.colorGreen.value
//                    cell.addbtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
//                    cell.addbtn.setTitle("ADDED", for: .normal)
//                    self.selectedProductId  = self.selectedProductId + "\(cell.productId)" + ","
//                }
//            }
//        }
//
       

     }
    
}
