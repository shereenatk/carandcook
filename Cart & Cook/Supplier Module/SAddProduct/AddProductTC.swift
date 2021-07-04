//
//  AddProductTC.swift
//  Cart & Cook
//
//  Created by Development  on 21/06/2021.
//

import Foundation
import UIKit
class AddProductTC : UITableViewCell, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var subTableView: UITableView!
    @IBOutlet weak var catNameLabel: UILabel!
    var productList : [String] = []
    var countryList : [String] = []
    var productIdList : [Int] = []
    var isAddSelected : [Bool] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        subTableView.delegate = self
        subTableView.dataSource = self
        subTableView.isScrollEnabled = true
    }
    @IBOutlet weak var subListBtn: UIButton!
    @IBAction func didSelectSubListBtn(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        let type = SAddProductVC.categoryList[indexPath.row]
        if let itemList = SAddProductVM.responseStatus {
            for item in itemList {
                let pdcttype = item.typeName ?? ""
                if(type == pdcttype) {
                    let prdctNAme = item.productName ?? ""
                    let origin = item.countryName ?? ""
                    let id = item.productID ?? 0
                    if(!productList.contains(prdctNAme)){
                        productList.append(prdctNAme)
                        productIdList.append(id)
                        countryList.append(origin)
                        isAddSelected.append(false)
                    }
                }
            }
        }
        self.subTableView.reloadData()
    }
    @objc func adddButtonAction(button:UIButton) {
        let myIndexPath = IndexPath(row: button.tag, section: 0)
        let cell = subTableView.cellForRow(at: myIndexPath) as! AddSubProductTC
        if(isAddSelected[button.tag]) {
            isAddSelected[button.tag] = false
            cell.addbtn.setTitleColor(AppColor.colorPrimary.value, for: .normal)
            cell.addbtn.tintColor = AppColor.colorPrimary.value
            cell.addbtn.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.addbtn.setTitle("ADD", for: .normal)
        } else {
            isAddSelected[button.tag] = true
            cell.addbtn.setTitleColor(AppColor.colorGreen.value, for: .normal)
            cell.addbtn.tintColor = AppColor.colorGreen.value
            cell.addbtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.addbtn.setTitle("ADDED", for: .normal)
        }

     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = subTableView.dequeueReusableCell(withIdentifier: "AddSubProductTC", for: indexPath) as? AddSubProductTC else {
            return UITableViewCell()
        }
        cell.nameLabel.text = productList[indexPath.row]
        cell.originLabel.text = countryList[indexPath.row]
        cell.productId  = productIdList[indexPath.row]
        cell.addbtn.tag = indexPath.row
        cell.addbtn.addTarget(self, action: #selector(adddButtonAction), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 80
        
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

extension UITableViewCell{

    var tableView:UITableView?{
        return superview as? UITableView
    }

    var indexPath:IndexPath?{
        return tableView?.indexPath(for: self)
    }

}

