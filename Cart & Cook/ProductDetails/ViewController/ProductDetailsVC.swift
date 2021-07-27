//
//  ProductDetailsVC.swift
//  Cart & Cook
//
//  Created by Development  on 23/05/2021.
//

import Foundation
import UIKit
import CoreData
import BadgeControl
class ProductDetailsVC: UIViewController, UITextFieldDelegate {
    var itemId = 0
    var tableItems: [NSManagedObject] = []
    var relatedItems: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var titleLabel: UILabel!
   
    @IBOutlet weak var cartcountBtn: UIButton!
    @IBOutlet weak var categoryListCV: UICollectionView!
    @IBOutlet weak var similarView: UIView!
    @IBOutlet weak var specificationview: UIView!
    @IBOutlet weak var pckgingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var shelfLifeLabel: UILabel!
    @IBOutlet weak var itemcountLabel: UILabel!
    @IBOutlet weak var strgReqLabel: UILabel!
    @IBOutlet weak var productImage: SquareImageView!
    private var upperLeftBadge: BadgeController!
    var quality = ""
    @IBOutlet weak var offerView: SquareView!{
        didSet{
            offerView.startShimmeringEffect()
        }
    }
    var getobjectVM = GetObjectVM()
    var image = UIImage(named: "cartcooklogo_new")
    @IBOutlet weak var actualPriceLabel: UILabel!{
        didSet{
            actualPriceLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var discriptionLabel: UILabel!
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    
    @IBOutlet weak var qtyView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var qtyLabel: UITextField!{
        didSet{
            qtyLabel.layer.cornerRadius = 15
            qtyLabel.layer.masksToBounds = true
        }
    }
    override func viewDidLoad() {
       
        qtyLabel.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        getProductDetails()
        getRelatedProducts()
        upperLeftBadge = BadgeController(for: cartcountBtn, in: .upperRightCorner, badgeBackgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) , badgeTextColor: .white, borderWidth: 0, badgeHeight: 20)
        if let count = UserDefaults.standard.value(forKey: CARTCOUNT) as? Int {
            upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: true)

        }
           upperLeftBadge.animateOnlyWhenBadgeIsNotYetPresent = true
           upperLeftBadge.animation = BadgeAnimations.leftRight
    }
    
    @IBAction func searchProduct(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    fileprivate func getProductDetails() {
        
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
            fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(itemId)")
            tableItems = try managedContext.fetch(fetchRequest)
            
            if let name =  self.tableItems[0].value(forKey: "item") as? String {
                self.titleLabel.text = name
                self.nameLabel.text = name
            }
            self.discriptionLabel.text = self.tableItems[0].value(forKey: "poductListModelDescription") as? String ?? ""
            self.originLabel.text = self.tableItems[0].value(forKey: "country") as? String ?? ""
            self.strgReqLabel.text = self.tableItems[0].value(forKey: "storageRequirements") as? String ?? ""
            self.pckgingLabel.text = self.tableItems[0].value(forKey: "packagingDisclaimer") as? String ?? ""
            self.itemcountLabel.text = self.tableItems[0].value(forKey: "itemCount") as? String ?? ""
            self.shelfLifeLabel.text = self.tableItems[0].value(forKey: "shelfLife") as? String ?? ""
            if let unint = self.tableItems[0].value(forKey: "unit") as? String  {
                
                let isPromotionItem = self.tableItems[0].value(forKey: "isPromotionItem") as? Bool ?? false
                   if(isPromotionItem){
                       self.offerView.isHidden = false
                       if let actualprice = self.tableItems[0].value(forKey: "promotionPrice") as? Double {
                           self.actualPriceLabel.text = "AED " + String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
                       }
                   } else {
                    self.offerView.isHidden =  true
                       if let unint = self.tableItems[0].value(forKey: "unit") as? String  {
                           if(self.isLowQuality()) {
                            quality = "M"
                            if let actualprice = self.tableItems[0].value(forKey: "priceLowQuality") as? Double {
                                self.actualPriceLabel.text = "AED " + String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
                            }
                           } else {
                            quality = "H"
                            if let actualprice = self.tableItems[0].value(forKey: "priceHighQuality") as? Double {
                                self.actualPriceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
                            }
                           }
                       }
                   }
                
            }
            
            if let cartCount = self.getCartCount(id: self.itemId) {
                    self.qtyLabel.text = "\(cartCount)"

            }
//            self.productImage.image = self.image
//            if let  byted =  tableItems[0].value(forKey: "thumbnail") as? Data {
//                self.productImage.image = UIImage(data: byted as! Data, scale: 0.7)
//    //           cell.activityIndicator.stopAnimating()
//            }
            
            if(isConnectedToInternet()) {
                if let file_path = self.tableItems[0].value(forKey: "image") as? String  {
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

                                self.productImage.image = decodedimage
                            }

                        }
                    }
                }

            }
      
            self.activityIndicator.stopAnimating()
        }catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    
    }
    
    fileprivate func getRelatedProducts() {
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
            if let name = nameLabel.text {
                fetchRequest.predicate = NSPredicate(format: "item = %@", "\(name)")
                 relatedItems = try managedContext.fetch(fetchRequest)
                self.categoryListCV.reloadData()
            }
          
        }catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    
    }
    
    @IBAction func addTapAction(_ sender: Any) {
        var  qty: Int =   Int(self.qtyLabel.text ?? "0") ?? 0
           qty = qty + 1
           self.subButton.isHidden = false
           self.qtyLabel.isHidden = false
        self.qtyLabel.text  = "\(qty)"
        self.updateCartCount(id: self.itemId, count: qty, quality: self.quality)
        upperLeftBadge = BadgeController(for: cartcountBtn, in: .upperRightCorner, badgeBackgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) , badgeTextColor: .white, borderWidth: 0, badgeHeight: 20)
        if let count = UserDefaults.standard.value(forKey: CARTCOUNT) as? Int {
            upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

        }
           
           upperLeftBadge.animateOnlyWhenBadgeIsNotYetPresent = true
           upperLeftBadge.animation = BadgeAnimations.leftRight
    }
    
    @IBAction func subTapAction(_ sender: Any) {
        var  qty: Int =   Int(self.qtyLabel.text ?? "0") ?? 0
           if(qty >= 1) {
              qty = qty - 1
        
            self.qtyLabel.text  = "\(qty)"
            self.subButton.isHidden = false
            self.qtyLabel.isHidden = false
         
           }
//           else {
//            qty = qty - 1
//            self.subButton.isHidden = true
//            self.qtyLabel.isHidden = true
//           }
  
        self.updateCartCount(id: self.itemId, count: qty, quality: self.quality)
        upperLeftBadge = BadgeController(for: cartcountBtn, in: .upperRightCorner, badgeBackgroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) , badgeTextColor: .white, borderWidth: 0, badgeHeight: 20)
        if let count = UserDefaults.standard.value(forKey: CARTCOUNT) as? Int {
            upperLeftBadge.addOrReplaceCurrent(with: String(count), animated: false)

        }
           
           upperLeftBadge.animateOnlyWhenBadgeIsNotYetPresent = true
           upperLeftBadge.animation = BadgeAnimations.leftRight
    }
   
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareInformation(_ sender: Any) {
        if let name = nameLabel.text,
           let origin = originLabel.text,
           let discount = discriptionLabel.text,
           let price = actualPriceLabel.text {
            let textToShare = [ name, origin, discount,price ]
//            let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = self.view
//            self.present(activityViewController, animated: true, completion: nil)
            
            
//            let textToShare = [text]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               
               if let popoverController = activityViewController.popoverPresentationController {
                   popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                   popoverController.sourceView = self.view
                   popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
               }

               self.present(activityViewController, animated: true, completion: nil)
        }
           
    }
    
    @IBAction func similarproducts(_ sender: Any) {
        specificationview.isHidden = true
        similarView.isHidden = false
    }
    
    @IBAction func specificationAction(_ sender: Any) {
        specificationview.isHidden = false
        similarView.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let count = textField.text {
            if let cartCount = Int(count) {
                self.updateCartCount(id: self.itemId, count: cartCount, quality: self.quality)
                
            }
        }
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
}
extension  ProductDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.relatedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  categoryListCV.dequeueReusableCell(withReuseIdentifier: "ProductListCVCell", for: indexPath) as? ProductListCVCell else {
               return UICollectionViewCell()
          }
         let isPromotionItem = self.relatedItems[indexPath.row].value(forKey: "isPromotionItem") as? Bool ?? false
            if(isPromotionItem){
                cell.offerView.isHidden = false
                if let unint = self.relatedItems[indexPath.row].value(forKey: "unit") as? String  {
                        if let actualprice = self.relatedItems[indexPath.row].value(forKey: "promotionPrice") as? Double {
                            cell.actualPriceLabel.text = "AED " + String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
                        }
                   
                }
            } else {
                cell.offerView.isHidden = true
                if let unint = self.relatedItems[indexPath.row].value(forKey: "unit") as? String  {
                    if(self.isLowQuality()) {
                        if let actualprice = self.relatedItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
                            cell.actualPriceLabel.text = "AED " + String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
                        }
                    } else {
                        if let actualprice = self.relatedItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
                            cell.actualPriceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100) + " / " + unint
                        }
                    }
                }
            }
        
        cell.discriptionLabel.text = self.relatedItems[indexPath.row].value(forKey: "poductListModelDescription") as? String ?? ""
        cell.nameLabel.text = self.relatedItems[indexPath.row].value(forKey: "item") as? String ?? ""
        cell.originLabel.text = self.relatedItems[indexPath.row].value(forKey: "country") as? String ?? ""
       
//        if let  byted =  self.relatedItems[indexPath.row].value(forKey: "thumbnail") as? Data {
//            cell.productImage.image = UIImage(data: byted as! Data, scale: 0.7)
////           cell.activityIndicator.stopAnimating()
//        }
        if(isConnectedToInternet()) {
            if let file_path = self.relatedItems[indexPath.row].value(forKey: "image") as? String  {
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
        itemID = self.relatedItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
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
    
//        return CGSize(width: 200, height: 350)
        
        let width = (collectionView.frame.width - 20) / 2.0
        
        if(self.quality == "M") {
            if let actualprice = self.relatedItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
                if(actualprice > 0) {
                    return CGSize(width: width, height: 300)
                } else {
                    return CGSize(width: 0, height: 0)
                }
            }
        }else if let actualprice = self.relatedItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
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
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

   
    
    
}
