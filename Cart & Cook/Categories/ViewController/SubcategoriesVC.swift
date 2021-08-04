//
//  SubcategoriesVC.swift
//  Cart & Cook
//
//  Created by Development  on 29/07/2021.
//

import Foundation
import UIKit
import DropDown
import CoreData
import BadgeControl

class SubcategoriesVC: UIViewController {
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<NSString, UIImage>!
    var isFoodSelected = false
    var isNonSelected = false
    var isServiceSelected = false
    typealias ImageCacheLoaderCompletionHandler = ((UIImage) -> ())
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noItemView: UIView!
    private var upperLeftBadge: BadgeController!
    
  
    var fetchedImage = [UIImage]()
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
    @IBOutlet weak var cartcountBtn: UIButton!
    var endRange = 0
    var titleVal = ""
    @IBOutlet weak var filterCloseBtn: UIButton!
    
    override func viewDidLoad() {
        upperLeftBadge = BadgeController(for: cartcountBtn, in: .upperRightCorner, badgeBackgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) , badgeTextColor: .white, borderWidth: 0, badgeHeight: 20)
        if let count = UserDefaults.standard.value(forKey: CARTCOUNT) as? Int {
            upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: true)

        }
           upperLeftBadge.animateOnlyWhenBadgeIsNotYetPresent = true
           upperLeftBadge.animation = BadgeAnimations.leftRight
    }
    override func viewWillAppear(_ animated: Bool) {
    
        self.titleLabel.text =  self.titleVal
        if(self.isLowQuality()){
            quality = "M"
        } else {
            quality = "H"
        }
        self.setupSideMenu()
       
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
            getProductList(type :HomeViewControllerVC.isCategoryselected)
    }
    
    @IBAction func filterBtnCloseaction(_ sender: Any) {
        filterSort = ""
        filterCounrty  = []
        filterUnit = []
       self.startRange = 0
       self.endRange = 0
        self.filterScrollView.isHidden = true
        self.filterCloseBtn.isHidden = true
        getProductList(type :HomeViewControllerVC.isCategoryselected)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func homeBtn(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 0
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    @IBAction func myOrderAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 4
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func buyAgainAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 3
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    @IBAction func categoriesAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 1
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    @IBAction func cartAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 2
            self.navigationController?.pushViewController(vc, animated:   false)

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
                                    categoryListCV.reloadData()
                                }
                            }
                        } else {
                            if let actualprice = item.value(forKey: "priceHighQuality") as? Double {
                                if(actualprice > 0.0) {
                                    self.tableItems.append(item)
                                    categoryListCV.reloadData()
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
  
   
}

   

extension  SubcategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryListCV:
            return self.tableItems.count
      
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryListCV:
            guard let cell =  categoryListCV.dequeueReusableCell(withReuseIdentifier: "ProductListCVCell", for: indexPath) as? ProductListCVCell else {
                  return UICollectionViewCell()
             }
           var itemID = 0
           itemID = self.tableItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
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
            let  byted =  tableItems[indexPath.row].value(forKey: "thumbnail") as? Data ??  Data()
               if(byted.count == 0) {
                   if(isConnectedToInternet()) {
                       if let file_path = self.tableItems[indexPath.row].value(forKey: "actualImage") as? String  {
                           cell.activityIndicator.startAnimating()
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
                                           let decodedimage = UIImage(data: dataDecoded, scale: 0.7)
           //                                if let updateCell = self.categoryListCV.cellForItem(at: indexPath){
                                               cell.productImage.image = decodedimage
                                               cell.activityIndicator.stopAnimating()
           //                                }
                                           let managedContext =
                                               self.appDelegate.persistentContainer.viewContext
                                           var attributeArray : [NSPredicate] = []
                                           let fetchRequest =
                                             NSFetchRequest<NSManagedObject>(entityName: "ProductList")
                                           
                                           do {
                                               fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(itemID)")

                                               let result = try? managedContext.fetch(fetchRequest)
                                               if(result?.count == 1) {
                                                   let dic = result![0]
                                               dic.setValue(dataDecoded, forKey: "thumbnail")
                                                   try managedContext.save()
                                               }
                                           } catch let error as NSError {
                                                         print("Could not fetch. \(error), \(error.userInfo)")
                                           }
                                   }

                               }

                       }

                   }
               } else {
                   let decodedimage = UIImage(data: byted, scale: 0.7)
                   cell.productImage.image = decodedimage
                   cell.activityIndicator.stopAnimating()
               }
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
            self.updateCartCount(id: itemID, count: qty, quality: self.quality)
         self.upperLeftBadge = BadgeController(for: self.cartcountBtn, in: .upperRightCorner, badgeBackgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) , badgeTextColor: .white, borderWidth: 0, badgeHeight: 20)
         if let count = UserDefaults.standard.value(forKey: CARTCOUNT) as? Int {
             self.upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

         }
            
         self.upperLeftBadge.animateOnlyWhenBadgeIsNotYetPresent = true
         self.upperLeftBadge.animation = BadgeAnimations.leftRight
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
            self.upperLeftBadge = BadgeController(for: self.cartcountBtn, in: .upperRightCorner, badgeBackgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) , badgeTextColor: .white, borderWidth: 0, badgeHeight: 20)
            if let count = UserDefaults.standard.value(forKey: CARTCOUNT) as? Int {
                self.upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

            }
               
            self.upperLeftBadge.animateOnlyWhenBadgeIsNotYetPresent = true
            self.upperLeftBadge.animation = BadgeAnimations.leftRight
                     }
            
            cell.clickEvent =  { cell in
                if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
                    vc.itemId = cell.id
                    vc.image = cell.productImage.image
                    self.navigationController?.pushViewController(vc, animated:   true)

                }
            }
           return cell
      
        default:
            return UICollectionViewCell()
        }
         
    }
    
   
   
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch collectionView {
//        case categoryListCV:
//            guard let cell = collectionView.cellForItem(at: indexPath) as? ProductListCVCell else {
//               return
//           }
//            if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
//                vc.itemId = cell.id
//                vc.image = cell.productImage.image
//                self.navigationController?.pushViewController(vc, animated:   true)
//
//            }
//      
//        default:
//           
//            return
//        }
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case categoryListCV:
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
             default:
                let width = (collectionView.frame.width ) / 3.0
                return CGSize(width: width, height: 150)
           
        }
        
       
        
        
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
        switch collectionView {
        case categoryListCV :
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        default:
            return UIEdgeInsets.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case categoryListCV :
            return 10
        default:
            return 0
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case categoryListCV :
            return 10
        default:
           return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoryListCV:
            if indexPath.row == self.tableItems.count - 1 {  //numberofitem count
                updateNextSet()
            }
        default:
            return
        }
           
    }

    func updateNextSet(){
           print("On Completetion")
           //requests another set of data (20 more items) from the server.
    }
    
}

extension SubcategoriesVC : UITextFieldDelegate {
    
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
