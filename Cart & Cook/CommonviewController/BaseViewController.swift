//
//  BaseViewController.swift
//  Site
//
//  Created by Development  on 16/02/2021.
//
import Foundation
import  UIKit
import SideMenu
import Toast_Swift
import CoreData
import Photos
import Alamofire

extension UIViewController {
    enum RecordingServiceError: String, Error {
        case canNotCreatePath = "Can not create path for new recording"
    }

    
    
    public func makeSettings() -> SideMenuSettings {
        let presentationStyle : SideMenuPresentationStyle = .menuSlideIn
        presentationStyle.backgroundColor = UIColor.white
        presentationStyle.menuStartAlpha = CGFloat(1)
        presentationStyle.menuScaleFactor = CGFloat(1)
        presentationStyle.onTopShadowOpacity = 1
        presentationStyle.presentingEndAlpha = CGFloat(1)
        presentationStyle.presentingScaleFactor = CGFloat(1)
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = view.frame.width * CGFloat(0.8)
        
        settings.blurEffectStyle = .light
        settings.statusBarEndAlpha = 0
        
        return settings
    }
    
    public func showMessageAlert(message : String){
        
        var style = ToastStyle()
        style.backgroundColor = UIColor.black
        style.messageColor = UIColor.white
        style.cornerRadius = CGFloat(4)
      //  style.messageFont = UIFont(name: ROBOTO_MEDIUM, size: CGFloat(15))!
        
        if let window = UIApplication.shared.windows.first {
            
            window.makeToast( message,duration : 2.0,position : .bottom, title: nil, image: nil,style: style, completion: nil)
            
        }
    }
    
    public func getFormatedDate(dateformat : String,timeStamp: Int)->String{
        
        let date = Date(timeIntervalSince1970: Double(timeStamp/1000))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
        dateFormatter.dateFormat = dateformat
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: date)
        
    }
    
    
    func getImage(path: String) -> Data {
        
        var dataDecoded: Data?
        let getobjectVM = GetObjectVM()
        getobjectVM.getObjectData(fileNAme: path) {  isSuccess, errorMessage  in
            if let  byte = getobjectVM.responseStatus?.fileBytes {
                var encoded64 = byte
                let remainder = encoded64.count % 4
                if remainder > 0 {
                    encoded64 = encoded64.padding(toLength: encoded64.count + 4 - remainder,
                                                  withPad: "=",
                                                  startingAt: 0)
                }
                 dataDecoded  = Data(base64Encoded: encoded64, options: .ignoreUnknownCharacters)!
               
            }
           
        }
        return dataDecoded ?? Data()
    }
    
    
    func getDocDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    public func isEmailValid(_ email: String) -> Bool {
        
        
        let emailRegEx =  "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$"
        
        var returnValue = true
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx, options: .caseInsensitive)
            
            let nsString = email as NSString
            
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            print("Email validation  result : \(results) ")
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return returnValue
    }
    
    
    public func isPasswordValid(_ password: String) -> Bool {
        
        
        let emailRegEx =  "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=\\S+$).{6,}$"
        
        var returnValue = true
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx, options: .caseInsensitive)
            
            let nsString = password as NSString
            
            let results = regex.matches(in: password, range: NSRange(location: 0, length: nsString.length))
            
            print("password validation  result : \(results) ")
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return returnValue
    }
   
    
    public func setupSideMenu() {
           guard let sidemenunavcontroller = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "slidermenunc") as? SideMenuNavigationController else { return }
         sidemenunavcontroller.settings = self.makeSettings()
         SideMenuManager.default.rightMenuNavigationController = nil
         SideMenuManager.default.leftMenuNavigationController =  sidemenunavcontroller
         sidemenunavcontroller.leftSide = true
    }
    
    
    public func isUserNameValid(_ userName: String) -> Bool {
        
        
        let userNameRegEx =  "\\w{5,18}"
        
        do {
            let Test = NSPredicate(format:"SELF MATCHES %@", userNameRegEx)
            return Test.evaluate(with: userName)
        }
    }
    public  func deleteAllData(_ entity:String) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
           fetchRequest.returnsObjectsAsFaults = false
        DispatchQueue.main.async {
            do
            {
             let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                 managedContext.delete(managedObjectData)
                    try managedContext.save()
                }
                print("deleted entity")
            } catch let error as NSError {
                print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
            }
        }
          
    }
    
    func getManagedObjectContext() -> NSManagedObjectContext{

        let delegate = UIApplication.shared.delegate as? AppDelegate

        return delegate!.persistentContainer.viewContext
    }
    func checkRecordExists(entity: String) -> Bool {
        let context = getManagedObjectContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)

        var results: [NSManagedObject] = []

        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return results.count > 0

    }
    
    public func isPhoneNoValid(phone : String) -> Bool { 
     //   "^(?:\\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\\d{7}$"
//        let phonerageex = "^\\+(?:[0-9]?){6,14}[0-9]$"
//        var returnValue = true
//
//        do {
//            let regex = try NSRegularExpression(pattern: phonerageex)
//
//
//            let nsString = phone as NSString
//
//            let results = regex.matches(in: phone, range: NSRange(location: 0, length: nsString.length))
//
//            if results.count == 0
//            {
//                returnValue = false
//            }
//
//        } catch let error as NSError {
//            print("invalid regex: \(error.localizedDescription)")
//            returnValue = false
//        }
//
//        return returnValue
    
               let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"

               let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
               return phoneCheck.evaluate(with: phone)
         
        
    }

    
    public  func setCartCount(id: Int)  {

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext2 = appDelegate.persistentContainer.viewContext
            var fetchResults: [NSManagedObject]  = []
            let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "CartList")
            do {
                fetchResults = try managedContext2.fetch(fetchRequest)
                self.tabBarController?.tabBar.items![2].badgeValue = String(fetchResults.count)
                UserDefaults.standard.set(fetchResults.count, forKey: CARTCOUNT)
            }catch let error as NSError {
                print("Could not fetch. cart \(error), \(error.userInfo)")
              }
  
    }
    
    public  func saveTimeSlot()  {
        let timeSloteVM = TimeSlotVM()
        timeSloteVM.getTimeSlotList(){  isSuccess, errorMessage  in
            if let slotList = timeSloteVM.responseStatus {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext2 =
                    appDelegate.persistentContainer.viewContext
                for slot in slotList {
                    let slotID = slot.slotID ?? 0
                    let slotDuration = slot.slotDuration ?? "0"
                    var fetchResults: [NSManagedObject]  = []
                    let fetchRequest =
                      NSFetchRequest<NSManagedObject>(entityName: "TimeSlotValues")
                    do {
                       fetchRequest.predicate = NSPredicate(format: "slotID = %@", "\(slotID)")
                        fetchResults = try managedContext2.fetch(fetchRequest)
                        if fetchResults.count == 0 {
                            DispatchQueue.main.async  {
                                let entity =
                                  NSEntityDescription.entity(forEntityName: "TimeSlotValues",
                                                             in: managedContext2)!
                                let property = NSManagedObject(entity: entity,
                                                             insertInto: managedContext2)
                                property.setValue(slotID, forKey: "slotID")
                                property.setValue(slotDuration, forKey: "slotDuration")
                               
                                DispatchQueue.main.async {
                                    do {
                                      try managedContext2.save()
                                       
                                    } catch let error as NSError {
                                      print("Could not save timeslot. \(error), \(error.userInfo)")
                                    }
                            }
                        }
                        } else {
                            fetchResults[0].setValue(slotID, forKey: "slotID")
                            fetchResults[0].setValue(slotDuration, forKey: "slotDuration")
                            do {
                              try managedContext2.save()
                               
                            } catch let error as NSError {
                              print("Could not save timeslot. \(error), \(error.userInfo)")
                            }
                        }
                    } catch let error as NSError {
                      print("Could not fetch. \(error), \(error.userInfo)")
                    }
                }
            }
            
        }
    }
    
    public  func getCartQuality(id: Int) -> String? {

        var quality: String = "0"
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext2 = appDelegate.persistentContainer.viewContext
            var fetchResults: [NSManagedObject]  = []
            let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "CartList")
            do {
               fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")
                fetchResults = try managedContext2.fetch(fetchRequest)
                if(fetchResults.count > 0) {
                    if let idVal = fetchResults[0].value(forKey: "itemID") as? Int {
                        if(id == idVal ) {
                            quality = fetchResults[0].value(forKey: "quality") as? String ?? "0"
                        }
                        
                    }
                   
                }
                setCartCount(id: id)
            }catch let error as NSError {
                print("Could not fetch. cart \(error), \(error.userInfo)")
              }
  
        return quality
    }
    
    public  func getCartCount(id: Int) -> Int? {

        var cartCount: Int = 0
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext2 = appDelegate.persistentContainer.viewContext
            var fetchResults: [NSManagedObject]  = []
            let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "CartList")
            do {
               fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")
                fetchResults = try managedContext2.fetch(fetchRequest)
                if(fetchResults.count > 0) {
                    if let idVal = fetchResults[0].value(forKey: "itemID") as? Int {
                        if(id == idVal ) {
                            cartCount = fetchResults[0].value(forKey: "cartCount") as? Int ?? 0
                        }
                        
                    }
                   
                }
                setCartCount(id: id)
            }catch let error as NSError {
                print("Could not fetch. cart \(error), \(error.userInfo)")
              }
  
        return cartCount
    }
    
    public  func getBuyagainCount(id: Int) -> Int? {

        var cartCount: Int = 0
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext2 = appDelegate.persistentContainer.viewContext
            var fetchResults: [NSManagedObject]  = []
            let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "BuyAgain")
            do {
               fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")
                fetchResults = try managedContext2.fetch(fetchRequest)
                if(fetchResults.count > 0) {
                    if let idVal = fetchResults[0].value(forKey: "itemID") as? Int {
                        if(id == idVal ) {
                            cartCount = fetchResults[0].value(forKey: "qty") as? Int ?? 0
                        }
                        
                    }
                   
                }
                setCartCount(id: id)
            }catch let error as NSError {
                print("Could not fetch. cart \(error), \(error.userInfo)")
              }
  
        return cartCount
    }
    
    public  func getBuyagainQuality(id: Int) -> String? {

        var quality: String = "0"
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext2 = appDelegate.persistentContainer.viewContext
            var fetchResults: [NSManagedObject]  = []
            let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "BuyAgain")
            do {
               fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")
                fetchResults = try managedContext2.fetch(fetchRequest)
                if(fetchResults.count > 0) {
                    if let idVal = fetchResults[0].value(forKey: "itemID") as? Int {
                        if(id == idVal ) {
                            quality = fetchResults[0].value(forKey: "quality") as? String ?? "0"
                        }
                        
                    }
                   
                }
            }catch let error as NSError {
                print("Could not fetch. cart \(error), \(error.userInfo)")
              }
  
        return quality
    }
    
    
    public  func updateCartCount(id: Int, count : Int, quality: String)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext2 = appDelegate.persistentContainer.viewContext
        var fetchResults: [NSManagedObject]  = []
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "CartList")
        do {
           fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")
            fetchResults = try managedContext2.fetch(fetchRequest)
           
            
            if fetchResults.count != 0 {
                if(count == 0) {
                    managedContext2.delete(fetchResults[0])
                    try managedContext2.save()
                } else {
//                    if let countVal = fetchResults[0].value(forKey: "cartCount") as? Int {
                      
                        fetchResults[0].setValue(count, forKey: "cartCount")
                        fetchResults[0].setValue(id, forKey: "itemID")
                    fetchResults[0].setValue(quality, forKey: "quality")
                        try managedContext2.save()
                }
            } else {
                let entity =
                  NSEntityDescription.entity(forEntityName: "CartList",
                                             in: managedContext2)!
                let property = NSManagedObject(entity: entity,
                                             insertInto: managedContext2)
                property.setValue(id, forKey: "itemID")
                property.setValue(count, forKey: "cartCount")
                property.setValue(quality, forKey: "quality")
                try managedContext2.save()
            }
            setCartCount(id: id)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        
    }
    
    
    public  func updateSupplierCartCount(id: Int, count : Int, price: Double, country: String, productName: String, unit: String)  {
        let supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext2 = appDelegate.persistentContainer.viewContext
        var fetchResults: [NSManagedObject]  = []
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "SupplierCart")
        let firstAttributePredicate = NSPredicate(format: "itemID = %@", "\(id)")
       let secondAttributePredicate = NSPredicate(format: "supplierId = %@", "\(supplierId)")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [firstAttributePredicate, secondAttributePredicate])
        do {
            fetchResults = try managedContext2.fetch(fetchRequest)
           
            
            if fetchResults.count != 0 {
                if(count == 0) {
                    managedContext2.delete(fetchResults[0])
                    try managedContext2.save()
                } else {
                        fetchResults[0].setValue(count, forKey: "cartCount")
                        try managedContext2.save()
                }
            } else {
                let entity =
                  NSEntityDescription.entity(forEntityName: "SupplierCart",
                                             in: managedContext2)!
                let property = NSManagedObject(entity: entity,
                                             insertInto: managedContext2)
                let total = Double(count) * price
                property.setValue(id, forKey: "itemID")
                property.setValue(count, forKey: "cartCount")
                property.setValue(supplierId, forKey: "supplierId")
                property.setValue(price, forKey: "price")
                property.setValue(country, forKey: "country")
                property.setValue(total, forKey: "total")
                property.setValue(productName, forKey: "productName")
                property.setValue(unit, forKey: "unit")
                try managedContext2.save()
            }
            setSupplierCartCount(supplierid: supplierId)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        
    }
    
    
    public  func getSupplierCartCount(id: Int) -> Int? {
        let supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
        var cartCount: Int = 0
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext2 = appDelegate.persistentContainer.viewContext
            var fetchResults: [NSManagedObject]  = []
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "SupplierCart")
        let firstAttributePredicate = NSPredicate(format: "itemID = %@", "\(id)")
       let secondAttributePredicate = NSPredicate(format: "supplierId = %@", "\(supplierId)")
       fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [firstAttributePredicate, secondAttributePredicate])
        do{
                fetchResults = try managedContext2.fetch(fetchRequest)
                if(fetchResults.count > 0) {
                    if let idVal = fetchResults[0].value(forKey: "itemID") as? Int {
                        if(id == idVal ) {
                            cartCount = fetchResults[0].value(forKey: "cartCount") as? Int ?? 0
                        }
                        
                    }
                   
                }
                setSupplierCartCount(supplierid: id)
            }catch let error as NSError {
                print("Could not fetch. cart \(error), \(error.userInfo)")
              }
  
        return cartCount
    }
    
    public  func setSupplierCartCount(supplierid: Int)  {
        let supplierid =  UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext2 = appDelegate.persistentContainer.viewContext
            var fetchResults: [NSManagedObject]  = []
            let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "SupplierCart")
            do {
                fetchRequest.predicate = NSPredicate(format: "supplierId = %@", "\(supplierid)")
                fetchResults = try managedContext2.fetch(fetchRequest)
                UserDefaults.standard.set(fetchResults.count, forKey: SUPPLIERCARTCOUNT)
//                print(fetchResults.count)
            }catch let error as NSError {
                print("Could not fetch. cart \(error), \(error.userInfo)")
              }
  
    }
    
    
    public func isUserLogin() -> Bool {
        
        if let login = UserDefaults.standard.value(forKey: IS_LOGIN) as? Bool {
            
            if login {
                return true
            }else{
                return false
            }
        }else{
            return false
        }
        
    }
    public func isConnectedToInternet() -> Bool {
        
        if let isConnected =  NetworkReachabilityManager()?.isReachable {
            
            if isConnected {
                
                return true
            }else{
                return false
            }
            
        } else{
            
            return false
        }
    }
    
    public func isLowQuality() -> Bool {
        
        if let isLowQuality = UserDefaults.standard.value(forKey: ISLOWQUALITY) as? Bool {
            if isLowQuality {
                
                return true
            }else{
                return false
            }
        }else{
            
            return false
        }
        
       
    }
     
  
    
  public  func hideKeyboardWhenTappedAround() {
           let tapGesture = UITapGestureRecognizer(target: self,
                            action: #selector(hideKeyboard))
           view.addGestureRecognizer(tapGesture)
       }

       @objc func hideKeyboard() {
           view.endEditing(true)
       }
    
}

extension PHAsset {

    var image : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
    }
   
}




