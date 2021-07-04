//
//  CategoriesVC.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//


import Foundation
import UIKit
import CoreData
import SideMenu
class CategoriesVC: UIViewController {
    
    @IBOutlet weak var noItemView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fullListScrollView: UIScrollView!
    @IBOutlet weak var shopbyCatLabel: UILabel!
  
    @IBOutlet weak var sizeFilterLabel: UILabel! {
        didSet{
            sizeFilterLabel.layer.cornerRadius = 10
            sizeFilterLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var countryFilterLabel: UILabel!{
        didSet{
            countryFilterLabel.layer.cornerRadius = 10
            countryFilterLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var priceFilterLabel: UILabel!{
        didSet{
            priceFilterLabel.layer.cornerRadius = 10
            priceFilterLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryListCV: UICollectionView!
    
    @IBOutlet weak var filterScrollView: UIScrollView!
    var quality = ""
    var tableItems: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var getobjectVM = GetObjectVM()
    var fromVC = ""
    var filterSort = ""
    var filterCounrty : [String] = []
    var filterUnit : [String] = []
    var startRange = 0
    var endRange = 0
    
    @IBOutlet weak var filterCloseBtn: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        if(self.isLowQuality()){
            quality = "M"
        } else {
            quality = "H"
        }
        self.setupSideMenu()
        setTitle()
        if(fromVC == "filter" ) {
            self.filterScrollView.isHidden = true
            self.filterCloseBtn.isHidden = true
            if(filterCounrty.count > 0) {
                self.countryFilterLabel.isHidden = false
                self.filterScrollView.isHidden = false
                self.filterCloseBtn.isHidden = false
            } else {
                self.countryFilterLabel.isHidden = true
            }
            if(filterUnit.count > 0) {
                self.sizeFilterLabel.isHidden = false
                self.filterScrollView.isHidden = false
                self.filterCloseBtn.isHidden = false
            } else {
                self.sizeFilterLabel.isHidden = true
            }
            if(endRange - startRange > 0) {
                self.filterScrollView.isHidden = false
                self.filterCloseBtn.isHidden = false
                self.priceFilterLabel.isHidden = false
            } else {
                self.priceFilterLabel.isHidden = true
            }
            
        } else {
            self.filterScrollView.isHidden = true
            self.filterCloseBtn.isHidden = true
        }
        if(HomeViewControllerVC.isCategoryselected == 0 && fromVC != "filter"  ) {
            fullListScrollView.isHidden = false
            categoryListCV.isHidden = true
            
        } else {
            
            getProductList(type :HomeViewControllerVC.isCategoryselected)

                fullListScrollView.isHidden = true
                categoryListCV.isHidden = false
           
            HomeViewControllerVC.isCategoryselected = 0
            
        }
    }
    
    @IBAction func filterBtnCloseaction(_ sender: Any) {
        filterSort = ""
        filterCounrty  = []
        filterUnit = []
       self.startRange = 0
       self.endRange = 0
        if let title = self.titleLabel.text {
            switch title {
            case "Fruits":
                HomeViewControllerVC.isCategoryselected = 1
            case "Vegetables":
                HomeViewControllerVC.isCategoryselected = 2
            case "Bakery":
                HomeViewControllerVC.isCategoryselected = 3
            case "Diary":
                HomeViewControllerVC.isCategoryselected = 4
            case "Meat & Fish":
                HomeViewControllerVC.isCategoryselected = 5
            case "Rice & Pulses":
                HomeViewControllerVC.isCategoryselected = 6
            case "Spices":
                HomeViewControllerVC.isCategoryselected = 7
            case "Beverages":
                HomeViewControllerVC.isCategoryselected = 8
            default:
                HomeViewControllerVC.isCategoryselected = 1
            }
        }
        self.filterScrollView.isHidden = true
        self.filterCloseBtn.isHidden = true
        getProductList(type :HomeViewControllerVC.isCategoryselected)
    }
    
    @IBAction func menuAction(_ sender: Any) {
          if let left = SideMenuManager.defaultManager.leftMenuNavigationController{
              present(left, animated: true, completion: nil)
          }
    }
    
    private func setTitle() {
        let type = HomeViewControllerVC.isCategoryselected
        switch type {
        case 1:
            self.titleLabel.text = "Fruits"
        case 2:
            self.titleLabel.text = "Vegetables"
        case 3:
            self.titleLabel.text = "Bakery"
        case 4:
            self.titleLabel.text = "Diary"
        case 5:
            self.titleLabel.text = "Meat & Fish"
        case 6:
            self.titleLabel.text = "Rice & Pulses"
        case 7:
            self.titleLabel.text = "Spices"
        case 8:
            self.titleLabel.text = "Beverages"
        default:
            self.titleLabel.text = "Categories"
        }
    }
    
    private func getProductList(type: Int) {
        self.tableItems = []
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        var attributeArray : [NSPredicate] = []
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "ProductList")
        
        do {
            var sortDescriptor = NSSortDescriptor(key:"item", ascending:true)
            if(self.filterSort == "Price : Low to High") {
                if(self.quality == "M") {
                    sortDescriptor = NSSortDescriptor(key: "priceLowQuality", ascending: true)
                } else {
                    sortDescriptor = NSSortDescriptor(key: "priceHighQuality", ascending: true)
                }
                
            }
           else if(self.filterSort == "Price : high to Low")  {
                if(self.quality == "M") {
                    sortDescriptor = NSSortDescriptor(key: "priceLowQuality", ascending: false)
                } else {
                    sortDescriptor = NSSortDescriptor(key: "priceHighQuality", ascending: false)
                }
           } else {
            sortDescriptor = NSSortDescriptor(key:"item", ascending:true)
           }
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            attributeArray.append(NSPredicate(format: "itemType = %@", "\(type)"))
            for item in filterCounrty {
                let predicate = NSPredicate(format: "country = %@", "\(item)")
                attributeArray.append(predicate)
            }
            for item in filterUnit {
                let predicate = NSPredicate(format: "unit = %@", "\(item)")
                attributeArray.append(predicate)
            }
            if(self.endRange - self.startRange > 0) {
                let pricePredicate = NSPredicate.init(format: "priceHighQuality <= %d && priceHighQuality >= %d", self.endRange, self.startRange)
                attributeArray.append(pricePredicate)
            }
            print(attributeArray)
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: attributeArray)
            
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                if let status =  item.value(forKey: "status") as? String{
                    if(status.lowercased() == "active") {
                        if(self.quality == "M") {
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
          
            self.activityIndicator.stopAnimating()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        categoryListCV.reloadData()
        if(self.tableItems.count <= 0) {
            self.noItemView.isHidden = false
        } else {
            self.noItemView.isHidden = true
        }
    }
    @IBAction func searchProduct(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    @IBAction func filterProduct(_ sender: Any) {
       
        let storyboard = UIStoryboard(name: "Productdetails", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
            pvc.modalPresentationStyle =
                UIModalPresentationStyle.overCurrentContext
        if let title = self.titleLabel.text {
            switch title {
            case "Fruits":
                HomeViewControllerVC.isCategoryselected = 1
            case "Vegetables":
                HomeViewControllerVC.isCategoryselected = 2
            case "Bakery":
                HomeViewControllerVC.isCategoryselected = 3
            case "Diary":
                HomeViewControllerVC.isCategoryselected = 4
            case "Meat & Fish":
                HomeViewControllerVC.isCategoryselected = 5
            case "Rice & Pulses":
                HomeViewControllerVC.isCategoryselected = 6
            case "Spices":
                HomeViewControllerVC.isCategoryselected = 7
            case "Beverages":
                HomeViewControllerVC.isCategoryselected = 8
            default:
                HomeViewControllerVC.isCategoryselected = 1
            }
        }
        pvc.filterUnit = self.filterUnit
        pvc.filterCounrty = self.filterCounrty
        pvc.filterSort = self.filterSort
            self.present(pvc, animated: true, completion: nil)
    }
    
    
    @IBAction func fruitsActionClick(_ sender: Any) {
        HomeViewControllerVC.isCategoryselected = 1
        setTitle()
        getProductList(type :HomeViewControllerVC.isCategoryselected)
        fullListScrollView.isHidden = true
        categoryListCV.isHidden = false
        HomeViewControllerVC.isCategoryselected = 0
        
    }
    @IBAction func vegActionClick(_ sender: Any) {
        
        HomeViewControllerVC.isCategoryselected = 2
        setTitle()
        getProductList(type :HomeViewControllerVC.isCategoryselected)
        fullListScrollView.isHidden = true
        categoryListCV.isHidden = false
        HomeViewControllerVC.isCategoryselected = 0
    }
    @IBAction func backeryActionClick(_ sender: Any) {
       
        HomeViewControllerVC.isCategoryselected = 3
        setTitle()
        getProductList(type :HomeViewControllerVC.isCategoryselected)
        fullListScrollView.isHidden = true
        categoryListCV.isHidden = false
        HomeViewControllerVC.isCategoryselected = 0
    }
    @IBAction func diaryActionClick(_ sender: Any) {
       
        HomeViewControllerVC.isCategoryselected = 4
        setTitle()
        getProductList(type :HomeViewControllerVC.isCategoryselected)
        fullListScrollView.isHidden = true
        categoryListCV.isHidden = false
        HomeViewControllerVC.isCategoryselected = 0
    }
    
    @IBAction func clearFilter(_ sender: Any) {
    }
    
    @IBAction func meatActionClick(_ sender: Any) {
       
        HomeViewControllerVC.isCategoryselected = 5
        setTitle()
        getProductList(type :HomeViewControllerVC.isCategoryselected)
        fullListScrollView.isHidden = true
        categoryListCV.isHidden = false
        HomeViewControllerVC.isCategoryselected = 0
    }
    @IBAction func riceActionClick(_ sender: Any) {
      
        
        HomeViewControllerVC.isCategoryselected = 6
        setTitle()
        getProductList(type :HomeViewControllerVC.isCategoryselected)
        fullListScrollView.isHidden = true
        categoryListCV.isHidden = false
        HomeViewControllerVC.isCategoryselected = 0
    }
    @IBAction func spiceActionClick(_ sender: Any) {
      
        HomeViewControllerVC.isCategoryselected = 7
        setTitle()
        getProductList(type :HomeViewControllerVC.isCategoryselected)
        fullListScrollView.isHidden = true
        categoryListCV.isHidden = false
        HomeViewControllerVC.isCategoryselected = 0
    }
    @IBAction func oilActionClick(_ sender: Any) {
     
        HomeViewControllerVC.isCategoryselected = 9
        setTitle()
        getProductList(type :HomeViewControllerVC.isCategoryselected)
        fullListScrollView.isHidden = true
        categoryListCV.isHidden = false
        HomeViewControllerVC.isCategoryselected = 0
    }
    
    @IBAction func beverageActionClick(_ sender: Any) {
       
        HomeViewControllerVC.isCategoryselected = 8
        setTitle()
        getProductList(type :HomeViewControllerVC.isCategoryselected)
        fullListScrollView.isHidden = true
        categoryListCV.isHidden = false
        HomeViewControllerVC.isCategoryselected = 0
    }
   
}
extension  CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  categoryListCV.dequeueReusableCell(withReuseIdentifier: "ProductListCVCell", for: indexPath) as? ProductListCVCell else {
               return UICollectionViewCell()
          }
//        if let isPromotionItem = self.tableItems[indexPath.row].value(forKey: "isPromotionItem") as? Bool {
//            if(isPromotionItem){
//                cell.offerView.isHidden = false
//            } else {
//                cell.offerView.isHidden = true
//            }
//        }
        if let unint = self.tableItems[indexPath.row].value(forKey: "unit") as? String  {
        if let isPromotionItem = self.tableItems[indexPath.row].value(forKey: "isPromotionItem") as? Bool {
            if(isPromotionItem){
                cell.offerView.isHidden = false
                if let actualprice = self.tableItems[indexPath.row].value(forKey: "promotionPrice") as? Double {
                    cell.actualPriceLabel.text = "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
                   
                }
            } else {
                cell.offerView.isHidden = true
                    if(self.quality == "M") {
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
        if let  byted =  tableItems[indexPath.row].value(forKey: "thumbnail") as? Data {
            cell.productImage.image = UIImage(data: byted as! Data, scale: 0.7)
//           cell.activityIndicator.stopAnimating()
        }
        
//        if(isConnectedToInternet()) {
//            if let file_path = self.tableItems[indexPath.row].value(forKey: "image") as? String  {
//                DispatchQueue.main.async {
//                    self.getobjectVM.getObjectData(fileNAme: file_path){  isSuccess, errorMessage  in
//                            var  fileBytes  = ""
//                        if let  byte = self.getobjectVM.responseStatus?.fileBytes {
//                            var encoded64 = byte
//                            let remainder = encoded64.count % 4
//                            if remainder > 0 {
//                                encoded64 = encoded64.padding(toLength: encoded64.count + 4 - remainder,
//                                                              withPad: "=",
//                                                              startingAt: 0)
//                            }
//                            let dataDecoded : Data = Data(base64Encoded: encoded64, options: .ignoreUnknownCharacters)!
//                            let decodedimage = UIImage(data: dataDecoded, scale: 0.5)
//
//                            cell.productImage.image = decodedimage
//                        }
//
//                    }
//                }
//            }
//
//        }
     
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
        cell.qtyLabel.tag = indexPath.row
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
            self.navigationController?.pushViewController(vc, animated:   true)

        }
       }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 2.0
        
        if(self.quality == "M") {
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

extension CategoriesVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let count = textField.text {
            let cpountInt = Int(count) ?? 0
            var quality = ""
            let indexPath = IndexPath(row: textField.tag, section: 0)
            guard let cell = self.categoryListCV.cellForItem(at: indexPath) as? ProductListCVCell else {
               return
           }
            
            
            let id = cell.id
            self.updateCartCount(id: id, count: cpountInt, quality: self.quality)
        }
    }
}
