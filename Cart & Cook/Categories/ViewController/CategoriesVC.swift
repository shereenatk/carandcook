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
import AlamofireImage
class CategoriesVC: UIViewController {
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<NSString, UIImage>!
    var isFoodSelected = false
    var isNonSelected = false
    var isServiceSelected = false
    typealias ImageCacheLoaderCompletionHandler = ((UIImage) -> ())
    
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var serviceCV: UICollectionView!
    @IBOutlet weak var nonFoodCV: UICollectionView!
    @IBOutlet weak var nonfoodHeight: NSLayoutConstraint!
    @IBOutlet weak var nonFoodView: UIView!
    @IBOutlet weak var fudStuffHeight: NSLayoutConstraint!
    @IBOutlet weak var foodStuffView: UIView!
    @IBOutlet weak var foodArrowBtn: UIButton!
    @IBOutlet weak var nonfoodArrowBtn: UIButton!
    @IBOutlet weak var serviceArrowBtn: UIButton!
    
    @IBOutlet weak var noItemView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fullListScrollView: UIScrollView!
    @IBOutlet weak var shopbyCatLabel: UILabel!
    @IBOutlet weak var foodStuffCV: UICollectionView!
    var foodCatImageArray = ["c_fruit", "c_veg", "c_meat", "c_poultry", "c_dairy", "c_bread", "c_rice", "c_spices", "c_bev", "c_organic"]
    var foodCatNameArray = ["Fruits", "Vegetables", "Meat & Fish", "Eggs & Poulty", "Diary", "Backery", "Rice & Pulses", "Spices", "Beverages", "Organic Foods"]
    var foodCatId = [1, 2, 5, 9, 4, 3, 6, 7, 8, 10]
    var nonfoodCatImageArray = ["c_packaging", "c_equip"]
    var nonFoodCatId = [11, 12]
    var nonfoodCatNameArray = ["Packaging Item", "Kitchen Equipment"]
    var serviceCatImageArray: [String] = []
    var serviceCatNameArray: [String] = []
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
    
    @IBOutlet weak var foodBtn: UIButton!{
        didSet{
            foodBtn.imageView?.contentMode = .scaleAspectFit
//            foodBtn.imageEdgeInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 5.0)
        }
    }
//    @IBOutlet weak var filterScrollView: UIScrollView!
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
    
//    @IBOutlet weak var filterCloseBtn: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        if(self.isLowQuality()){
            quality = "M"
        } else {
            quality = "H"
        }
        self.setupSideMenu()
       
//        if(fromVC == "filter" ) {
//            self.filterScrollView.isHidden = true
//            self.filterCloseBtn.isHidden = true
//            if(filterCounrty.count > 0) {
//                self.countryFilterLabel.isHidden = false
//                self.filterScrollView.isHidden = false
//                self.filterCloseBtn.isHidden = false
//            } else {
//                self.countryFilterLabel.isHidden = true
//            }
//            if(filterUnit.count > 0) {
//                self.sizeFilterLabel.isHidden = false
//                self.filterScrollView.isHidden = false
//                self.filterCloseBtn.isHidden = false
//            } else {
//                self.sizeFilterLabel.isHidden = true
//            }
//            if(endRange - startRange > 0) {
//                self.filterScrollView.isHidden = false
//                self.filterCloseBtn.isHidden = false
//                self.priceFilterLabel.isHidden = false
//            } else {
//                self.priceFilterLabel.isHidden = true
//            }
//
//        } else {
//            self.filterScrollView.isHidden = true
//            self.filterCloseBtn.isHidden = true
//        }
//            fudStuffHeight.constant = CGFloat(self.foodCatImageArray.count * 150 ) + 10.0
            self.titleLabel.text = "Categories"
            foodStuffCV.reloadData()
            fullListScrollView.isHidden = false
            nonFoodCV.reloadData()
            serviceCV.reloadData()
            switch HomeViewControllerVC.isMainCategoryselected {
            case 1:
                self.foodArrowBtn.setTitle("▼", for: .normal)
                self.foodStuffView.visibility = .visible
                self.nonfoodArrowBtn.setTitle("▲", for: .normal)
                self.nonFoodView.visibility = .gone
                self.serviceArrowBtn.setTitle("▲", for: .normal)
                self.serviceView.visibility = .gone
                
            case 2:
                self.nonfoodArrowBtn.setTitle("▼", for: .normal)
                self.nonFoodView.visibility = .visible
                self.foodArrowBtn.setTitle("▲", for: .normal)
                self.foodStuffView.visibility = .gone
                self.serviceArrowBtn.setTitle("▲", for: .normal)
                self.serviceView.visibility = .gone
            default:
                self.serviceArrowBtn.setTitle("▼", for: .normal)
                self.serviceView.visibility = .visible
                self.foodArrowBtn.setTitle("▲", for: .normal)
                self.foodStuffView.visibility = .gone
                self.nonfoodArrowBtn.setTitle("▲", for: .normal)
                self.nonFoodView.visibility = .gone
            }
      
    }
    
//    @IBAction func filterBtnCloseaction(_ sender: Any) {
//        filterSort = ""
//        filterCounrty  = []
//        filterUnit = []
//       self.startRange = 0
//       self.endRange = 0
//        self.filterScrollView.isHidden = true
//        self.filterCloseBtn.isHidden = true
//        getProductList(type :HomeViewControllerVC.isCategoryselected)
//    }
    
    @IBAction func menuAction(_ sender: Any) {
          if let left = SideMenuManager.defaultManager.leftMenuNavigationController{
              present(left, animated: true, completion: nil)
          }
    }
    
//    private func getProductList(type: Int) {
//        self.tableItems = []
//        guard let appDelegate =
//          UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedContext =
//          appDelegate.persistentContainer.viewContext
//        var attributeArray : [NSPredicate] = []
//        let fetchRequest =
//          NSFetchRequest<NSManagedObject>(entityName: "ProductList")
//
//        do {
//            var sortDescriptor = NSSortDescriptor(key:"item", ascending:true)
//            if(self.filterSort == "Price : Low to High") {
//                if(self.quality == "M") {
//                    sortDescriptor = NSSortDescriptor(key: "priceLowQuality", ascending: true)
//                } else {
//                    sortDescriptor = NSSortDescriptor(key: "priceHighQuality", ascending: true)
//                }
//
//            }
//           else if(self.filterSort == "Price : high to Low")  {
//                if(self.quality == "M") {
//                    sortDescriptor = NSSortDescriptor(key: "priceLowQuality", ascending: false)
//                } else {
//                    sortDescriptor = NSSortDescriptor(key: "priceHighQuality", ascending: false)
//                }
//           } else {
//            sortDescriptor = NSSortDescriptor(key:"item", ascending:true)
//           }
//            fetchRequest.sortDescriptors = [sortDescriptor]
//
//            attributeArray.append(NSPredicate(format: "itemType = %@", "\(type)"))
//            for item in filterCounrty {
//                let predicate = NSPredicate(format: "country = %@", "\(item)")
//                attributeArray.append(predicate)
//            }
//            for item in filterUnit {
//                let predicate = NSPredicate(format: "unit = %@", "\(item)")
//                attributeArray.append(predicate)
//            }
//            if(self.endRange - self.startRange > 0) {
//                let pricePredicate = NSPredicate.init(format: "priceHighQuality <= %d && priceHighQuality >= %d", self.endRange, self.startRange)
//                attributeArray.append(pricePredicate)
//            }
//            print(attributeArray)
//            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: attributeArray)
//
//            let items = try managedContext.fetch(fetchRequest)
//            for item in items {
//                if let status =  item.value(forKey: "status") as? String{
//                    if(status.lowercased() == "active") {
//                        if(self.quality == "M") {
//                            if let actualprice = item.value(forKey: "priceLowQuality") as? Double {
//                                if(actualprice > 0.0) {
//                                    self.tableItems.append(item)
//                                    categoryListCV.reloadData()
//                                }
//                            }
//                        } else {
//                            if let actualprice = item.value(forKey: "priceHighQuality") as? Double {
//                                if(actualprice > 0.0) {
//                                    self.tableItems.append(item)
//                                    categoryListCV.reloadData()
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//
//            self.activityIndicator.stopAnimating()
//        } catch let error as NSError {
//          print("Could not fetch. \(error), \(error.userInfo)")
//        }
//
//        if(self.tableItems.count <= 0) {
//            self.noItemView.isHidden = false
//        } else {
//            self.noItemView.isHidden = true
//        }
//    }
    @IBAction func searchProduct(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
//    @IBAction func filterProduct(_ sender: Any) {
//
//        let storyboard = UIStoryboard(name: "Productdetails", bundle: nil)
//            let pvc = storyboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
//            pvc.modalPresentationStyle =
//                UIModalPresentationStyle.overCurrentContext
//        if let title = self.titleLabel.text {
//            switch title {
//            case "Fruits":
//                HomeViewControllerVC.isCategoryselected = 1
//            case "Vegetables":
//                HomeViewControllerVC.isCategoryselected = 2
//            case "Bakery":
//                HomeViewControllerVC.isCategoryselected = 3
//            case "Diary":
//                HomeViewControllerVC.isCategoryselected = 4
//            case "Meat & Fish":
//                HomeViewControllerVC.isCategoryselected = 5
//            case "Rice & Pulses":
//                HomeViewControllerVC.isCategoryselected = 6
//            case "Spices":
//                HomeViewControllerVC.isCategoryselected = 7
//            case "Beverages":
//                HomeViewControllerVC.isCategoryselected = 8
//            default:
//                HomeViewControllerVC.isCategoryselected = 1
//            }
//        }
//        pvc.filterUnit = self.filterUnit
//        pvc.filterCounrty = self.filterCounrty
//        pvc.filterSort = self.filterSort
//            self.present(pvc, animated: true, completion: nil)
//    }
    
    @IBAction func foodstuffBtnAction(_ sender: Any) {
        if(self.isFoodSelected) {
            self.foodArrowBtn.setTitle("▲", for: .normal)
            self.isFoodSelected = false
            self.foodStuffView.visibility = .gone
            
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
            self.view.setNeedsUpdateConstraints()
        } else {
            self.foodStuffView.visibility = .visible
            self.foodArrowBtn.setTitle("▼", for: .normal)
            self.isFoodSelected = true
            self.foodStuffCV.setNeedsLayout()
            self.foodStuffCV.setNeedsDisplay()
            self.foodStuffCV.setNeedsUpdateConstraints()
        }
    }

    @IBAction func nonFoodButtonAction(_ sender: Any) {
        if(self.isNonSelected) {
            self.nonfoodArrowBtn.setTitle("▲", for: .normal)
            self.isNonSelected = false
            self.nonFoodView.visibility = .gone
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
            self.view.setNeedsUpdateConstraints()
        } else {
            self.nonFoodView.visibility = .visible
            self.nonfoodArrowBtn.setTitle("▼", for: .normal)
            self.isNonSelected = true
            self.nonFoodCV.setNeedsLayout()
            self.nonFoodCV.setNeedsDisplay()
            self.nonFoodCV.setNeedsUpdateConstraints()
        }
    }
    
    @IBAction func serviceBtnAction(_ sender: Any) {
        if(self.isServiceSelected) {
            self.serviceArrowBtn.setTitle("▲", for: .normal)
            self.isServiceSelected = false
            self.serviceView.visibility = .gone
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
            self.view.setNeedsUpdateConstraints()
        } else {
            self.serviceView.visibility = .visible
            self.serviceArrowBtn.setTitle("▼", for: .normal)
            self.isServiceSelected = true
            self.serviceCV.setNeedsLayout()
            self.serviceCV.setNeedsDisplay()
            self.serviceCV.setNeedsUpdateConstraints()
        }
    }
    
   
   
}

   

extension  CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
       
        case foodStuffCV:
            return self.foodCatImageArray.count
        case nonFoodCV:
            return self.nonfoodCatImageArray.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
       
        case foodStuffCV:
            guard let cell =  foodStuffCV.dequeueReusableCell(withReuseIdentifier: "SubCategoryCC", for: indexPath) as? SubCategoryCC else {
                  return UICollectionViewCell()
             }
            cell.catId = self.foodCatId[indexPath.row]
            cell.catButton.setImage(UIImage(named: self.foodCatImageArray[indexPath.row]), for: .normal)
            cell.catNameLabel.text = self.foodCatNameArray[indexPath.row]
            return cell
        case nonFoodCV:
            guard let cell =  nonFoodCV.dequeueReusableCell(withReuseIdentifier: "NonFoodSubCategoriesCC", for: indexPath) as? NonFoodSubCategoriesCC else {
                  return UICollectionViewCell()
             }
            cell.catId = nonFoodCatId[indexPath.row]
            cell.catButton.setImage(UIImage(named: self.nonfoodCatImageArray[indexPath.row]), for: .normal)
            cell.catNameLabel.text = self.nonfoodCatNameArray[indexPath.row]
            return cell
        case serviceCV:
            guard let cell =  serviceCV.dequeueReusableCell(withReuseIdentifier: "ServiceCC", for: indexPath) as? ServiceCC else {
                  return UICollectionViewCell()
             }
            cell.catButton.setImage(UIImage(named: self.serviceCatImageArray[indexPath.row]), for: .normal)
            cell.catNameLabel.text = self.serviceCatNameArray[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
         
    }
    
   
   
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        
        case foodStuffCV:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SubCategoryCC else {
               return
           }
        
            HomeViewControllerVC.isCategoryselected = cell.catId
            if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SubcategoriesVC") as? SubcategoriesVC {
                vc.titleVal = cell.catNameLabel.text ?? ""
                self.navigationController?.pushViewController(vc, animated:   false)

            }
            fullListScrollView.isHidden = true
            
//            HomeViewControllerVC.isMainCategoryselected = 0
        case nonFoodCV:
            guard let cell = collectionView.cellForItem(at: indexPath) as? NonFoodSubCategoriesCC else {
               return
           }
            // setTitle(catId: 1): cell.catId)
           
            HomeViewControllerVC.isCategoryselected = cell.catId
            if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SubcategoriesVC") as? SubcategoriesVC {
                vc.titleVal = cell.catNameLabel.text ?? ""
                self.navigationController?.pushViewController(vc, animated:   false)

            }
            fullListScrollView.isHidden = true
          
        
//            HomeViewControllerVC.isMainCategoryselected = 0
            return
        default:
            self.titleLabel.text =  "Categories"
            return
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        
                let width = (collectionView.frame.width ) / 3.0
                return CGSize(width: width, height: 150)
           
        }
        
       

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
        switch collectionView {
       
        default:
            return UIEdgeInsets.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
       
        default:
            return 0
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        
        default:
           return 0
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        switch collectionView {
//
//        default:
//            return
//        }]
//
//
//    }

    func updateNextSet(){
           print("On Completetion")
           //requests another set of data (20 more items) from the server.
    }
    
}

extension CategoriesVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let count = textField.text {
//            let cpountInt = Int(count) ?? 0
//            var quality = ""
//            let indexPath = IndexPath(row: textField.tag, section: 0)
////            guard let cell = self.categoryListCV.cellForItem(at: indexPath) as? ProductListCVCell else {
////               return
////           }
//
//
//            let id = cell.id
//            self.updateCartCount(id: id, count: cpountInt, quality: self.quality)
//        }
    }
}
