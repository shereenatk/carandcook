//
//  SearchViewController.swift
//  Cart & Cook
//
//  Created by Development  on 27/06/2021.
//

import Foundation
import UIKit
import DropDown
import CoreData

class SearchViewController: UIViewController , UISearchBarDelegate, UITextFieldDelegate {
    var data: [String] = []
    var itemId : [Int] = []
    var dataFiltered: [String] = []
    var dropButton = DropDown()
    var tableItems : [NSManagedObject] = []
    var quality = ""
    var getobjectVM = GetObjectVM()
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var categoryListCV: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.searchTextField.textColor = .white
            searchBar.searchTextField.leftView?.tintColor = .white
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        if(self.isLowQuality()) {
            self.quality = "M"
        } else {
            self.quality = "H"
        }
        getProductList()
    }
    private func getProductList() {
       
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "ProductList")
        do {
            let sort = NSSortDescriptor(key:"item", ascending:true)
            fetchRequest.sortDescriptors = [sort]
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                if let status =  item.value(forKey: "status") as? String{
                    if(status.lowercased() == "active") {
                        let name = item.value(forKey: "item") as? String ?? ""
                        let id =  item.value(forKey: "itemID") as? Int ?? 0
                        if(self.itemId.count == 0) {
                            self.itemId.append(id)
                            self.data.append(name)
                        } else {
                            if(!self.data.contains(name)){
                                self.itemId.append(id)
                                self.data.append(name)
                            }
                        }
                    }
                }
            }
            dataFiltered = data

                dropButton.anchorView = searchBar
                dropButton.bottomOffset = CGPoint(x: 0, y:(dropButton.anchorView?.plainView.bounds.height)!)
                dropButton.backgroundColor = .white
                dropButton.direction = .bottom

                dropButton.selectionAction = { [unowned self] (index: Int, item: String) in
//                    print("Selected item: \(item) at index: \(index)") //Selected item: code at index: 0
                    getResultProductList(name: item)
                }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    private func getResultProductList(name: String) {
        self.tableItems = []
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "ProductList")
        do {
            let sort = NSSortDescriptor(key:"item", ascending:true)
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.predicate = NSPredicate(format: "item = %@", "\(name)")
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                if let status =  item.value(forKey: "status") as? String{
                    if(status.lowercased() == "active") {
                        if(self.isLowQuality()) {
                            if let actualprice = item.value(forKey: "priceLowQuality") as? Double {
                                if(actualprice > 0.0) {
                                    self.tableItems.append(item)
                                }
                            }
                        } else {
                            if let actualprice = item.value(forKey: "priceHighQuality") as? Double {
                                if(actualprice > 0.0) {
                                    self.tableItems.append(item)
                                }
                            }
                        }
                        
                    }
                }
            }
          
//            self.activityIndicator.stopAnimating()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        categoryListCV.reloadData()
        if(self.tableItems.count <= 0) {
            self.errorImage.isHidden = false
        } else {
            self.errorImage.isHidden = true
        }
    }
   
}

extension  SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  categoryListCV.dequeueReusableCell(withReuseIdentifier: "ProductListCVCell", for: indexPath) as? ProductListCVCell else {
               return UICollectionViewCell()
          }
        if let unint = self.tableItems[indexPath.row].value(forKey: "unit") as? String  {
        if let isPromotionItem = self.tableItems[indexPath.row].value(forKey: "isPromotionItem") as? Bool {
            if(isPromotionItem){
                cell.offerView.isHidden = false
                if let actualprice = self.tableItems[indexPath.row].value(forKey: "promotionPrice") as? Double {
                    cell.actualPriceLabel.text = "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
                   
                }
            } else {
                cell.offerView.isHidden = true
                    if(self.isLowQuality()) {
                        if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
                            cell.actualPriceLabel.text = "AED " +  String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
                            
                        }
                    } else {
                        if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
                            cell.actualPriceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
                           
                        }
                    
                }
            }
        }
    }
        cell.discriptionLabel.text = self.tableItems[indexPath.row].value(forKey: "poductListModelDescription") as? String ?? ""
        cell.nameLabel.text = self.tableItems[indexPath.row].value(forKey: "item") as? String ?? ""
        cell.originLabel.text = self.tableItems[indexPath.row].value(forKey: "country") as? String ?? ""
//        if let unint = self.tableItems[indexPath.row].value(forKey: "unit") as? String  {
//            if(self.isLowQuality()) {
//                if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
//                    cell.actualPriceLabel.text = "AED " +  "\(actualprice)" + " / " + unint
//                }
//            } else {
//                if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
//                    cell.actualPriceLabel.text =  "AED " + "\(actualprice)" + " / " + unint
//                }
//            }
//        }
//        if let  byted =  tableItems[indexPath.row].value(forKey: "thumbnail") as? Data {
//            cell.productImage.image = UIImage(data: byted as! Data, scale: 0.7)
////           cell.activityIndicator.stopAnimating()
//        }
        
        if(isConnectedToInternet()) {
            if let file_path = self.tableItems[indexPath.row].value(forKey: "image") as? String  {
                DispatchQueue.main.async {
                    self.getobjectVM.getObjectData(fileNAme: file_path){  isSuccess, errorMessage  in
                            var  fileBytes  = ""
                        if let  byte = self.getobjectVM.responseStatus?.fileBytes {
                            var encoded64 = byte
                            let remainder = encoded64.count % 4
                            if remainder > 0 {
                                encoded64 = encoded64.padding(toLength: encoded64.count + 4 - remainder,
                                                              withPad: "=",
                                                              startingAt: 0)
                            }
                            let dataDecoded : Data = Data(base64Encoded: encoded64, options: .ignoreUnknownCharacters)!
                            let decodedimage = UIImage(data: dataDecoded, scale: 1)

                            cell.productImage.image = decodedimage
                        }

                    }
                }
            }

        }
     
        var itemID = 0
        itemID = self.tableItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
        if let cartCount = self.getCartCount(id: itemID) {
            if(cartCount > 0) {
                cell.subButton.isHidden = false
                cell.qtyLabel.isHidden = false
                cell.qtyLabel.text = "\(cartCount)"
            } else {
                cell.subButton.isHidden = true
                cell.qtyLabel.isHidden = true
               
            }
            
        }
        cell.id = itemID
        cell.addTapAction = { cell in
         var  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
            qty = qty + 1
            cell.subButton.isHidden = false
            cell.qtyLabel.isHidden = false
         cell.qtyLabel.text  = "\(qty)"
            self.updateCartCount(id: itemID, count: qty, quality: self.quality)
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
      
            self.updateCartCount(id: itemID, count: qty, quality: self.quality)
                  }
        return cell
    }
    
   
   
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductListCVCell else {
                                       return
                                   }
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
            vc.itemId = cell.id
            vc.image = cell.productImage.image
            self.navigationController?.pushViewController(vc, animated:   true)

        }
       }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 2.0
        
        if(self.isLowQuality()) {
            if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
                if(actualprice > 0) {
                    return CGSize(width: width, height: 300)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            }
        }else if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
                if(actualprice > 0) {
                    return CGSize(width: width, height: 300)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            } else {
                return CGSize(width: 0, height: 0)
            
        }
    
        return CGSize(width: width, height: 300)
        
        
        
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


extension SearchViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataFiltered = searchText.isEmpty ? data : data.filter({ (dat) -> Bool in
            dat.range(of: searchText, options: .caseInsensitive) != nil
        })

        dropButton.dataSource = dataFiltered
        dropButton.show()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        for ob: UIView in ((searchBar.subviews[0] )).subviews {
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        dataFiltered = data
        dropButton.hide()
    }
}
