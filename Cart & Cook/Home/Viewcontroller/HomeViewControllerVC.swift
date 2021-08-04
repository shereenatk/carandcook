//
//  HomeViewControllerVC.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation
import UIKit
import CoreData
import SideMenu
import ImageSlideshow
class HomeViewControllerVC: UIViewController {
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var categotyLabel: UILabel!
    @IBOutlet weak var catStack: UIStackView!
    var productListM: [PoductListModelElement] = []
    var productListVM = PoductListVM()
    var priceUpdate = ProductUpdateVM()
    @IBOutlet weak var categorystackHeight: NSLayoutConstraint!
    var priceUpdateVM = PriceUpdateVM()
    var getobjectVM = GetObjectVM()
    var tableItems: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer = Timer()
    @IBOutlet weak var topDealLabel: UILabel!
    static var isMainCategoryselected = 0
    static var isCategoryselected = 0
    @IBOutlet weak var tvHeight: NSLayoutConstraint!
    @IBOutlet weak var topDealsTV: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dueValLabel: UILabel!
    var newIdList: [Int] = []
    @IBOutlet weak var overDueView: UIView!{
        didSet{
            overDueView.startShimmeringEffect()
        }
    }
    
    var outstanding = 0.0
     var prepaidAmount = 0.0
    var fromVc = ""
    var quality = ""
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<NSString, UIImage>!
    typealias ImageCacheLoaderCompletionHandler = ((UIImage) -> ())
    var imageSource: [ImageSource] = [ImageSource(image: UIImage(named: "why_banner")!), ImageSource(image: UIImage(named: "slider1")!) , ImageSource(image: UIImage(named: "slider2")!), ImageSource(image: UIImage(named: "slider3")!)]
    
    
    override func viewDidLoad() {
        
       self.outstangingAmountApi()
        priceUpdateTimer()
        if(self.isLowQuality()) {
            quality = "M"
        } else {
            quality = "H"
        }
        slideShow.contentScaleMode = .scaleToFill
        slideShow.slideshowInterval = 2
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = AppColor.colorPrimary.value
        pageIndicator.pageIndicatorTintColor = AppColor.colorGreen.value
        slideShow.pageIndicator = pageIndicator
        
        self.setupSideMenu()
       
        if(fromVc == "verification") {
            categorystackHeight.constant = 0
            catStack.isHidden = true
            categotyLabel.isHidden = true
            topDealsTV.isUserInteractionEnabled = false
        }
        timer = Timer.scheduledTimer(timeInterval: 900, target: self, selector: #selector(self.updatePrice), userInfo: nil, repeats: true)
        slideShow.setImageInputs(self.imageSource)
       
    }
    
    private func outstangingAmountApi()  {
        let overDueVM = OverDueVM()
      
        overDueVM.getOverDueAmount(){  isSuccess, errorMessage  in
           let outstanding = overDueVM.responseStatus?.OutstandingAmount ?? 0.0
           let  prepaidAmount = overDueVM.responseStatus?.PrepaidAmount ?? 0.0
            if(outstanding > 0) {
            
                self.dueValLabel.text = "Your Amount Due is : AED " + "\(outstanding)"
                self.overDueView.isHidden = false
            } else {
                
                self.overDueView.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var supplierBtn: UIButton!{
        didSet{
            supplierBtn.layer.cornerRadius = 20
        }
    }
    
    @IBAction func openWallet(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MyWalletVC") as? MyWalletVC {
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.stopAnimating()
        self.navigationController?.isNavigationBarHidden = true
        if(isConnectedToInternet()){
            getProductList()
            self.saveTimeSlot()
        }
    }
    
    
    @IBAction func supplierAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierHomeVC") as? SupplierHomeVC {
            UserDefaults.standard.setValue(0, forKey: SUPPLIERID)
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
    @IBAction func menuAction(_ sender: Any) {

                                  
          if let left = SideMenuManager.defaultManager.leftMenuNavigationController{
              
              present(left, animated: true, completion: nil)
          }
                           
    }
    
    fileprivate func getProductList() {
        newIdList = []
        self.productListVM.getProductList(){  isSuccess, errorMessage  in
            if let count =  self.productListVM.responseStatus?.count {
                if(count > 0) {
                    DispatchQueue.main.async {
                        let managedContext2 =
                            self.appDelegate.persistentContainer.viewContext
                        for index in 0...count - 1 {
                            let country = self.productListVM.responseStatus?[index].country ?? ""
                            let image = self.productListVM.responseStatus?[index].thumbnailImage ?? ""
                            let isPromotionItem = self.productListVM.responseStatus?[index].isPromotionItem ?? false
                            let item = self.productListVM.responseStatus?[index].item ?? "0"
                            let itemCode = self.productListVM.responseStatus?[index].itemCode ?? "0"
                            let itemCount = self.productListVM.responseStatus?[index].itemCount ?? "0"
                            let itemID = self.productListVM.responseStatus?[index].itemID ?? 0
                            self.newIdList.append(itemID)
                            let priceHighQuality = self.productListVM.responseStatus?[index].priceHighQuality ?? 0.0
                            let priceLowQuality = self.productListVM.responseStatus?[index].priceLowQuality ?? 0.0
                            let itemType = self.productListVM.responseStatus?[index].itemType ?? ""
                            let packagingDisclaimer = self.productListVM.responseStatus?[index].packagingDisclaimer ?? "0"
                            let  poductListModelDescription = self.productListVM.responseStatus?[index].poductListModelDescription ?? ""
                            let actualImage =  self.productListVM.responseStatus?[index].image ?? ""
                            let promotionPrice = self.productListVM.responseStatus?[index].promotionPrice ?? 0.0
                            let shelfLife = self.productListVM.responseStatus?[index].shelfLife ?? ""
                            let status = self.productListVM.responseStatus?[index].status ?? ""
                            let storageRequirements = self.productListVM.responseStatus?[index].storageRequirements ?? "0"
                            let unit = self.productListVM.responseStatus?[index].unit ?? ""
                            let weight = self.productListVM.responseStatus?[index].weight
                            var fetchResults: [NSManagedObject]  = []
                            let fetchRequest =
                              NSFetchRequest<NSManagedObject>(entityName: "ProductList")
                            do {
                               fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(itemID)")
                                fetchResults = try managedContext2.fetch(fetchRequest)
                                let entity =
                                  NSEntityDescription.entity(forEntityName: "ProductList",
                                                             in: managedContext2)!
                                let property = NSManagedObject(entity: entity,
                                                             insertInto: managedContext2)
                                if fetchResults.count == 0 {
                                    DispatchQueue.main.async  {
                                       
                                        property.setValue(weight, forKey: "weight")
                                        property.setValue(country, forKey: "country")
                                        property.setValue(image, forKey: "image")
                                        property.setValue(isPromotionItem, forKey: "isPromotionItem")
                                        property.setValue(item, forKey: "item")
                                        property.setValue(itemCode, forKey: "itemCode")
                                        property.setValue(itemCount, forKey: "itemCount")
                                        property.setValue(itemID, forKey: "itemID")
                                        property.setValue(itemType, forKey: "itemType")
                                        property.setValue(packagingDisclaimer, forKey: "packagingDisclaimer")
                                        property.setValue(poductListModelDescription, forKey: "poductListModelDescription")
                                        property.setValue(priceHighQuality, forKey: "priceHighQuality")
                                        property.setValue(priceLowQuality, forKey: "priceLowQuality")
                                        property.setValue(promotionPrice, forKey: "promotionPrice")
                                        property.setValue(shelfLife, forKey: "shelfLife")
                                        property.setValue(storageRequirements, forKey: "storageRequirements")
                                        property.setValue(status, forKey: "status")
                                        property.setValue(unit, forKey: "unit")
                                        property.setValue(actualImage, forKey: "actualImage")
                                        let data = Data()
                                        property.setValue(data, forKey: "thumbnail")
                                            do {
                                              try managedContext2.save()
                                                if(index == count - 1 ) {
                                                    self.getOfflineData()
                                                   
                                                }

                                            } catch let error as NSError {
                                              print("Could not save. \(error), \(error.userInfo)")
                                            }
                                    }
                                
                                } else {
                                    let savedActualImage =  fetchResults[0].value(forKey: "actualImage") as? String ?? ""
                                    if( savedActualImage != actualImage ) {
                                        fetchResults[0].setValue(actualImage, forKey: "actualImage")
                                        let data = Data()
                                        fetchResults[0].setValue(data, forKey: "thumbnail")
                                    }
                                    fetchResults[0].setValue(weight, forKey: "weight")
                                    fetchResults[0].setValue(country, forKey: "country")
                                    fetchResults[0].setValue(image, forKey: "image")
                                    fetchResults[0].setValue(isPromotionItem, forKey: "isPromotionItem")
                                    fetchResults[0].setValue(item, forKey: "item")
                                    fetchResults[0].setValue(itemCode, forKey: "itemCode")
                                    fetchResults[0].setValue(itemCount, forKey: "itemCount")
                                    fetchResults[0].setValue(itemID, forKey: "itemID")
                                    fetchResults[0].setValue(itemType, forKey: "itemType")
                                    fetchResults[0].setValue(packagingDisclaimer, forKey: "packagingDisclaimer")
                                    fetchResults[0].setValue(poductListModelDescription, forKey: "poductListModelDescription")
                                    fetchResults[0].setValue(priceHighQuality, forKey: "priceHighQuality")
                                    fetchResults[0].setValue(priceLowQuality, forKey: "priceLowQuality")
                                    fetchResults[0].setValue(promotionPrice, forKey: "promotionPrice")
                                    fetchResults[0].setValue(shelfLife, forKey: "shelfLife")
                                    fetchResults[0].setValue(storageRequirements, forKey: "storageRequirements")
                                    fetchResults[0].setValue(status, forKey: "status")
                                    fetchResults[0].setValue(unit, forKey: "unit")
                                   
                                        do {
                                          try managedContext2.save()
                                            if(index == count - 1 ) {
                                                self.getOfflineData()
                                               
                                            }

                                        } catch let error as NSError {
                                          print("Could not save. \(error), \(error.userInfo)")
                                        }
                                
                                }
                            } catch let error as NSError {
                              print("Could not fetch. \(error), \(error.userInfo)")
                            }
                            
                         
                        }
                        
                    }
                   
                    
                }
                
            }
            
        }
    }
    
    @objc func updatePrice(){
        getProductList()
    }
    
    private func getOfflineData() {
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
            let sort = NSSortDescriptor(key:"item", ascending:false)
            fetchRequest.sortDescriptors = [sort]
           let items = try managedContext.fetch(fetchRequest)
            for item in items {
                if let oldlId = item.value(forKey: "itemID") as? Int {
                    if(!newIdList.contains(oldlId)){
                        deleteItem(id: oldlId)
                    }
                }
                
                if let status =  item.value(forKey: "status") as? String,
                   let isPromotionItem = item.value(forKey: "isPromotionItem") as? Bool{
                    if(isPromotionItem == true && status.lowercased() == "active"){
                        if let price = item.value(forKey: "promotionPrice") as? Double {
                            if(price > 0) {
                                self.tableItems.append(item)
                            }
                            
                        }
                       
                    }
                }
            }
           
           
            self.activityIndicator.stopAnimating()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        if(self.tableItems.count == 0) {
            self.topDealLabel.isHidden = true
            self.tvHeight.constant = 0.0
        } else {
            self.topDealLabel.isHidden = false
            self.tvHeight.constant = CGFloat(175 * self.tableItems.count)
            topDealsTV.reloadData()
        }
       
    }
    
    func deleteItem(id: Int) {
       
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext2 =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "ProductList")
        var fetchResults: [NSManagedObject]  = []
        do {
           fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")
            fetchResults = try managedContext2.fetch(fetchRequest)
            if fetchResults.count > 0 {
                for item in fetchResults {
                    managedContext2.delete(item)
                    do {
                      try managedContext2.save()

                    } catch let error as NSError {
                      print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                }
              
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func foodActionClick(_ sender: Any) {
        if let pvc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
           let controllers = pvc.viewControllers
            pvc.selectedIndex = 1
            let vc = controllers![1] as! CategoriesVC
            HomeViewControllerVC.isMainCategoryselected = 1
            vc.isFoodSelected = true
            vc.isNonSelected = false
            vc.isServiceSelected = false
            self.navigationController?.pushViewController(pvc, animated: false)
        }
    }
    @IBAction func nonFoodActionClick(_ sender: Any) {
        if let pvc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
           let controllers = pvc.viewControllers
            pvc.selectedIndex = 1
            let vc = controllers![1] as! CategoriesVC
            HomeViewControllerVC.isMainCategoryselected = 2
            vc.isNonSelected = true
            vc.isFoodSelected = false
            vc.isServiceSelected = false
            self.navigationController?.pushViewController(pvc, animated: false)
        }
    }
    
    @IBAction func serviceActionClick(_ sender: Any) {
        if let pvc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
           let controllers = pvc.viewControllers
            pvc.selectedIndex = 1
            let vc = controllers![1] as! CategoriesVC
            HomeViewControllerVC.isMainCategoryselected = 3
            vc.isNonSelected = false
            vc.isFoodSelected = false
            vc.isServiceSelected = true
            self.navigationController?.pushViewController(pvc, animated: false)
        }

    }
    

    
    @IBAction func searchProduct(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    
   public func saveThumbImage(id: Int, thumnNail: String) {
        let managedContext =
                   self.appDelegate.persistentContainer.viewContext
   
              let entity2 =
                NSEntityDescription.entity(forEntityName: "ProductList",
                                           in: managedContext)!
               var finalData: Data?

           self.getobjectVM.getObjectData(fileNAme: thumnNail){  isSuccess, errorMessage  in
                   var  fileBytes  = ""
                   if let  byte = self.getobjectVM.responseStatus?.fileBytes {
                       fileBytes = byte
                    finalData = Data(base64Encoded: fileBytes, options: .ignoreUnknownCharacters)!
                    let fetchRequest =
                          NSFetchRequest<NSManagedObject>(entityName: "ProductList")

                    do {
                        fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")

                        let result = try? managedContext.fetch(fetchRequest)
//                        print(result?.count, result)
                        if(result?.count == 1) {
                            let dic = result![0]
                        dic.setValue(finalData, forKey: "thumbnail")
                            try managedContext.save()
                        }
//                        if(index == homecount - 1) {
////                           print( "DB Updated")
////                            self.refreshControl.endRefreshing()
//                        }

                    } catch let error as NSError {
                                  print("Could not fetch. \(error), \(error.userInfo)")
                    }
//                    property.setValue(dataDecoded, forKey: "path")
                   }

           }
       
    }
    
    
//    func saveThumbImage() {
//        let homeCount = self.productListVM.responseStatus?.count ?? 1
//        for index in 0...homeCount - 1 {
//            let managedContext =
//                self.appDelegate.persistentContainer.viewContext
//
//           let entity2 =
//             NSEntityDescription.entity(forEntityName: "ProductList",
//                                        in: managedContext)!
//           let thumnNail  = self.productListVM.responseStatus?[index].thumbnailImage ?? ""
//           let id = self.productListVM.responseStatus?[index].itemID ?? 0
//            var finalData: Data?
//
//           self.getobjectVM.getObjectData(fileNAme: thumnNail){  isSuccess, errorMessage  in
//                   var  fileBytes  = ""
//                   if let  byte = self.getobjectVM.responseStatus?.fileBytes {
//                       fileBytes = byte
//                    finalData = Data(base64Encoded: fileBytes, options: .ignoreUnknownCharacters)!
//                    let fetchRequest =
//                          NSFetchRequest<NSManagedObject>(entityName: "ProductList")
//
//                    do {
//                        fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")
//
//                        let result = try? managedContext.fetch(fetchRequest)
////                        print(result?.count, result)
//                        if(result?.count == 1) {
//                            let dic = result![0]
//                        dic.setValue(finalData, forKey: "thumbnail")
//                            try managedContext.save()
//                        }
////                        if(index == homecount - 1) {
//////                           print( "DB Updated")
//////                            self.refreshControl.endRefreshing()
////                        }
//
//                    } catch let error as NSError {
//                                  print("Could not fetch. \(error), \(error.userInfo)")
//                    }
////                    property.setValue(dataDecoded, forKey: "path")
//                   }
//
//           }
//       }
//    }
    
    
    
    func priceUpdateTimer() {
        Timer.scheduledTimer(withTimeInterval: 900, repeats: true) { timer in
            self.priceUpdate.getPriceUpdate() {isSuccess, errorMessage  in
                if let  count =  self.priceUpdate.responseStatus?.count {
                    if(count > 0) {
                        let managedContext2 =
                            self.appDelegate.persistentContainer.viewContext
                        for index in 0...count - 1 {
                            let itemID = self.priceUpdate.responseStatus?[index].itemID ?? 0
                            let priceHighQuality = self.priceUpdate.responseStatus?[index].priceHighQuality ?? 0.0
                            let priceLowQuality = self.priceUpdate.responseStatus?[index].priceLowQuality ?? 0.0
                            var fetchResults: [NSManagedObject]  = []
                            let fetchRequest =
                              NSFetchRequest<NSManagedObject>(entityName: "ProductList")
                            do {
                               fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(itemID)")
                                fetchResults = try managedContext2.fetch(fetchRequest)
                                if fetchResults.count != 0 {
                                    DispatchQueue.main.async  {
                                        let entity =
                                          NSEntityDescription.entity(forEntityName: "ProductList",
                                                                     in: managedContext2)!
                                       
                                        fetchResults[0].setValue(itemID, forKey: "itemID")
                                        fetchResults[0].setValue(priceHighQuality, forKey: "priceHighQuality")
                                        fetchResults[0].setValue(priceLowQuality, forKey: "priceLowQuality")
                                        DispatchQueue.main.async {
                                            do {
                                              try managedContext2.save()

                                            } catch let error as NSError {
                                              print("Could not save. \(error), \(error.userInfo)")
                                            }
                                    }
                                }
                                }
                            } catch let error as NSError {
                              print("Could not fetch. \(error), \(error.userInfo)")
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    func  thumbDownload(imagePath: String, completionHandler: @escaping ImageCacheLoaderCompletionHandler) {
        
        if let url = URL(string: imagePath) {
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) in
                if let data = try? Data(contentsOf: url) {
//                    print(url)
                    do {
                        let fetchedDataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
//                        print(fetchedDataDictionary!)
                        let message = fetchedDataDictionary?["fileBytes"] as? String ?? ""
                        let dataDecoded : Data = Data(base64Encoded: message, options: .ignoreUnknownCharacters)!
                        if let img  = UIImage(data: dataDecoded) {
                        self.cache.setObject(img, forKey: imagePath as NSString)
                                           DispatchQueue.main.async {
                                               completionHandler(img)
                                           }
                        }
                      
                    }
                    catch let error as NSError {
                        print(error.debugDescription)
                    }
                }
               
            })
            task.resume()
        }
        
    }
}
extension HomeViewControllerVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableItems.count
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopDelasTVCell", for: indexPath) as? TopDelasTVCell else {
            return UITableViewCell()
        }
        var itemID = 0
        itemID = self.tableItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
        
//        if let  byted =  tableItems[indexPath.row].value(forKey: "thumbnail") as? Data {
//            cell.productImage.image = UIImage(data: byted as! Data, scale: 0.7)
////           cell.activityIndicator.stopAnimating()
//        }
        
        
        let  byted =  tableItems[indexPath.row].value(forKey: "thumbnail") as? Data ??  Data()
           if(byted.count == 0) {
               if(isConnectedToInternet()) {
                   if let file_path = self.tableItems[indexPath.row].value(forKey: "actualImage") as? String  {
                   
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
                                   DispatchQueue.main.async {
                                       let dataDecoded : Data = Data(base64Encoded: encoded64, options: .ignoreUnknownCharacters)!
                                       let decodedimage = UIImage(data: dataDecoded, scale: 0.7)
       //                                if let updateCell = self.categoryListCV.cellForItem(at: indexPath){
                                           cell.productImage.image = decodedimage
       //                                }
                                       let managedContext =
                                           self.appDelegate.persistentContainer.viewContext
                                       var attributeArray : [NSPredicate] = []
                                       let fetchRequest =
                                         NSFetchRequest<NSManagedObject>(entityName: "ProductList")
                                       
                                       do {
                                           fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(itemID)")

                                           let result = try? managedContext.fetch(fetchRequest)
                   //                        print(result?.count, result)
                                           if(result?.count == 1) {
                                               let dic = result![0]
                                           dic.setValue(dataDecoded, forKey: "thumbnail")
                                               try managedContext.save()
                                           }
                   //                        if(index == homecount - 1) {
                   ////                           print( "DB Updated")
                   ////                            self.refreshControl.endRefreshing()
                   //                        }

                                       } catch let error as NSError {
                                                     print("Could not fetch. \(error), \(error.userInfo)")
                                       }

                                   }

                               }

                           }

                   }

               }
           } else {
               let decodedimage = UIImage(data: byted, scale: 0.7)
//                                if let updateCell = self.categoryListCV.cellForItem(at: indexPath){
                   cell.productImage.image = decodedimage
//                                }
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
//                            let decodedimage = UIImage(data: dataDecoded, scale: 1)
//
//                            cell.productImage.image = decodedimage
//                        }
//
//                    }
//                }
//            }
//
//        }
        
//        cell.productImage.image = image
        
        cell.nameLabel.text = self.tableItems[indexPath.row].value(forKey: "item") as? String ?? ""
        cell.discriptionLabel.text = self.tableItems[indexPath.row].value(forKey: "poductListModelDescription") as? String ?? ""
        cell.originLabel.text = self.tableItems[indexPath.row].value(forKey: "country") as? String ?? ""
        cell.actualPriceLabel.textColor = .black
       
        if(self.quality == "M") {
            if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
                cell.actualPriceLabel.text = "AED " +  String(format: "%.2f", ceil(actualprice*100)/100)
            }
        } else {
            if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
                cell.actualPriceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100)
            }
        }
//                cell.activityIndicator.stopAnimating()
        
        if let price = self.tableItems[indexPath.row].value(forKey: "promotionPrice") as? Double {
            cell.offerPriceLabel.text  = "AED " + String(format: "%.2f", ceil(price*100)/100)
        }
        
        if let cartCount = self.getCartCount(id: itemID) {
            if(cartCount > 0) {
                cell.subButton.isHidden = false
                cell.qtyLabel.isHidden = false
                cell.qtyLabel.text = "\(cartCount)"
            } else {
                cell.subButton.isHidden = true
                cell.qtyLabel.isHidden = true
                cell.qtyLabel.text = "\(cartCount)"
               
            }
            
        }
        cell.id = itemID
        if(self.fromVc == "verification") {
            cell.addButton.isHidden = true
        }
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
        
//        if(isConnectedToInternet()) {
//                    if let url = self.tableItems[indexPath.row].value(forKey: "image") as? String  {
//        thumbDownload(imagePath: url) { (image) in
//              // Before assigning the image, check whether the current cell is visible
//              if let updateCell = tableView.cellForRow(at: indexPath) {
//                cell.productImage.image = image
//
//                cell.nameLabel.text = self.tableItems[indexPath.row].value(forKey: "item") as? String ?? ""
//                cell.discriptionLabel.text = self.tableItems[indexPath.row].value(forKey: "poductListModelDescription") as? String ?? ""
//                cell.originLabel.text = self.tableItems[indexPath.row].value(forKey: "country") as? String ?? ""
//                cell.actualPriceLabel.textColor = .black
//
//                if(self.quality == "M") {
//                    if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceLowQuality") as? Double {
//                        cell.actualPriceLabel.text = "AED " +  String(format: "%.2f", ceil(actualprice*100)/100)
//                    }
//                } else {
//                    if let actualprice = self.tableItems[indexPath.row].value(forKey: "priceHighQuality") as? Double {
//                        cell.actualPriceLabel.text =  "AED " + String(format: "%.2f", ceil(actualprice*100)/100)
//                    }
//                }
////                cell.activityIndicator.stopAnimating()
//
//                if let price = self.tableItems[indexPath.row].value(forKey: "promotionPrice") as? Double {
//                    cell.offerPriceLabel.text  = "AED " + String(format: "%.2f", ceil(price*100)/100)
//                }
//                var itemID = 0
//                itemID = self.tableItems[indexPath.row].value(forKey: "itemID") as? Int ?? 0
//                if let cartCount = self.getCartCount(id: itemID) {
//                    if(cartCount > 0) {
//                        cell.subButton.isHidden = false
//                        cell.qtyLabel.isHidden = false
//                        cell.qtyLabel.text = "\(cartCount)"
//                    } else {
//                        cell.subButton.isHidden = true
//                        cell.qtyLabel.isHidden = true
//                        cell.qtyLabel.text = "\(cartCount)"
//
//                    }
//
//                }
//                cell.id = itemID
//                if(self.fromVc == "verification") {
//                    cell.addButton.isHidden = true
//                }
//                cell.addTapAction = { cell in
//                 var  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
//                    qty = qty + 1
//                    cell.subButton.isHidden = false
//                    cell.qtyLabel.isHidden = false
//                 cell.qtyLabel.text  = "\(qty)"
//                    self.updateCartCount(id: itemID, count: qty, quality: self.quality)
//                }
//                cell.subTapAction = { cell in
//
//                    var  qty: Int =   Int(cell.qtyLabel.text ?? "0") ?? 0
//                       if(qty > 1) {
//                          qty = qty - 1
//
//                        cell.qtyLabel.text  = "\(qty)"
//                        cell.subButton.isHidden = false
//                        cell.qtyLabel.isHidden = false
//
//                       } else {
//                        qty = qty - 1
//                        cell.subButton.isHidden = true
//                        cell.qtyLabel.isHidden = true
//                       }
//
//                    self.updateCartCount(id: itemID, count: qty, quality: self.quality)
//                          }
//              }
//          }
//                    }
//
////    }
//
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        
            return 165
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
            return
        }
        if let vc =  UIStoryboard(name: "Productdetails", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
            let cell = tableView.cellForRow(at: indexPath) as! TopDelasTVCell
            vc.itemId = cell.id
            vc.image = cell.productImage.image
            self.navigationController?.pushViewController(vc, animated:   true)

        }
        
    }

    
//    fileprivate func  updateCartCount(id: Int, qty: Int) {
//        let managedContext2 =
//            self.appDelegate.persistentContainer.viewContext
//        var fetchResults: [NSManagedObject]  = []
//        let fetchRequest =
//          NSFetchRequest<NSManagedObject>(entityName: "ProductList")
//        do {
//           fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")
//            fetchResults = try managedContext2.fetch(fetchRequest)
//            if fetchResults.count != 0 {
//                fetchResults[0].setValue(qty, forKey: "cartCount")
//                try managedContext2.save()
//            }
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//          }
//        
//        
//    }
    
    
    

    
}
