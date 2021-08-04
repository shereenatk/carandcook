//
//  PaymentVC.swift
//  Cart & Cook
//
//  Created by Development  on 27/05/2021.
//

import Foundation
import UIKit
import CoreData
import WebKit
class PaymentVC: UIViewController, WKScriptMessageHandler , WKNavigationDelegate, WKUIDelegate{

    var placeOrderVM = OrderVM()
    var placeOrderM: OrderModel?
    var selectedIdex = 0
    var selectedCardId = 0
    var addresId = 0
    var timeSlote = ""
    var fromVc = ""
    var savedCardVM = SavedCardVM()
    var savedCardM : SavedCardsModel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var total = "0"
    var totalAmount = 0.0
    var vat = "0"
    var fullTotal = ""
    var subtotal = "0"
    var selectedIndex = -1
    var tableItems: [NSManagedObject] = []
    var addressItems: [NSManagedObject] = []
    var transactionID = ""
     var   amountPaid  = 0.0
    var cardNumber = ""
    var cardExpiry  = ""
    var cardType = ""
    var cardTypId = ""
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var saveCardTV: UITableView!
    @IBOutlet weak var cardListView: UIView!
    @IBOutlet weak var neCardView: ShadowView!
//    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webviewOuterView: UIView!
    @IBOutlet weak var subtotalLabel: UILabel!
    let contentController = WKUserContentController()
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var cashonDeliveryView: UIView!
    @IBOutlet weak var savedCardHeight: NSLayoutConstraint!
    
    private var webView: WKWebView!

    
    override func viewDidLoad() {
        if(self.fromVc != "quickbuy") {
            getcartList()
        } else {
            
        }
        
        totalLabel.text = fullTotal
        subtotalLabel.text = subtotal
        vatLabel.text = vat
       
        getAddrss()
    
        
        
        
      
        
        let contentController = WKUserContentController()
           contentController.add(self, name: "observer")

           let configuration = WKWebViewConfiguration()
           configuration.userContentController = contentController
        
           // JavaScript to inject
//           let src = """
//           document.body.insertAdjacentHTML('beforebegin',"<header><meta
//           name='viewport' content='width=device-width, initial-scale=1.0,
//           maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
//           </header>");
//           """
//           let script = WKUserScript(source: src,
//                                     injectionTime: .atDocumentStart,
//                                     forMainFrameOnly: false)
//        contentController.addUserScript(script)
           
        
        
        
        
        
        

           self.webView = WKWebView( frame: CGRect(x: 10, y: 200, width: self.view.bounds.size.width - 30 , height: self.view.bounds.size.height - 250), configuration: configuration)
        self.webView.contentMode = .scaleAspectFit
        self.webView.isOpaque = true
           
           webView.contentMode = .scaleAspectFit
           webView.sizeToFit()
           webView.autoresizesSubviews = true
        webView.isUserInteractionEnabled = true
        self.webView.navigationDelegate = self
        webView.isHidden  = true
           self.view.addSubview(self.webView!)
    }
    
    
//    private func getWKWebViewConfiguration() -> WKWebViewConfiguration {
//           let userController = WKUserContentController()
//           userController.add(self, name: "observer")
//           let configuration = WKWebViewConfiguration()
//           configuration.userContentController = userController
//           return configuration
//       }
    override func viewWillAppear(_ animated: Bool) {
        getSavedCardLists()
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var reViewBtn: UIButton!{
        didSet{
            
            reViewBtn.backgroundColor = .white
            reViewBtn.layer.borderColor = AppColor.borderColor.cgColor
            reViewBtn.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var paymnetBtn: UIButton!{
        didSet{
            paymnetBtn.backgroundColor = AppColor.colorPrimary.value
            paymnetBtn.layer.borderColor = AppColor.borderColor.cgColor
            paymnetBtn.layer.borderWidth = 2
        }
    }
    
    
    @IBOutlet weak var addressBtn: UIButton!{
        didSet{
            addressBtn.backgroundColor = .white
            addressBtn.layer.borderColor = AppColor.borderColor.cgColor
            addressBtn.layer.borderWidth = 2
        }
    }
  
    
    
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            backBtn.layer.cornerRadius = 15
            
        }
    }
    @IBOutlet weak var cashOnBtn: UIButton!{
        didSet{
            cashOnBtn.tag = 0
        }
    }
    @IBOutlet weak var cardOnBtn: UIButton!{
        didSet{
            cardOnBtn.tag = 1
        }
    }
    
    @IBAction func neCardAction(_ sender: Any) {
        
        neCardView.layer.borderWidth = 3
        neCardView.layer.borderColor = AppColor.colorGreen.cgColor
        selectedCardId = 0
        saveCardTV.reloadData()
       
        loadPaymnetPage()
    }
    

    @IBAction func goToReviewCheckout(_ sender: Any) {
        
        let controllers = self.navigationController?.viewControllers
                      for vc in controllers! {
                        if vc is ReviewVC {
                          _ = self.navigationController?.popToViewController(vc as! ReviewVC, animated: true)
                        }
                     }
    }
    @IBAction func goToAddressCheckout(_ sender: Any) {
        
        let controllers = self.navigationController?.viewControllers
                      for vc in controllers! {
                        if vc is CheckoutVC {
                          _ = self.navigationController?.popToViewController(vc as! CheckoutVC, animated: true)
                        }
                     }
    }
    private func getAddrss() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "AddressList")
        do {
            fetchRequest.predicate = NSPredicate(format: "id = %@", "\(self.addresId)")
             addressItems = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
//    private func setupWKWebview() {
//            self.webView = WKWebView(frame: self.view.bounds, configuration: self.getWKWebViewConfiguration())
//            self.view.addSubview(self.webView)
//        }
//
    
    
    private func loadPaymnetPage() {
//        self.setupWKWebview()
        
        
        self.cashonDeliveryView.isHidden = true
        self.cardListView.isHidden = true
        self.webviewOuterView.isHidden = false
        self.webView.isHidden = false
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.sizeToFit()
        let custometrId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
//        let url = URL(string: "http://10.1.12.30:91/Payment/ConfirmOrder?TotalAmount=\(totalAmount)&CustomerID=\(self.selectedCardId)&CustomerCardID=\(custometrId)")!
        let url = URL(string: "https://cartandcook.com/Payment/ConfirmOrder/ConfirmOrder?TotalAmount=\(totalAmount)&CustomerCardID=\(self.selectedCardId)&CustomerID=\(custometrId)")!
        print(url)
        webView.load(URLRequest(url: url))
        self.activityIndicator.startAnimating()
    }
    
    private func getSavedCardLists() {
        savedCardVM.getSavedCards()  { isSuccess, errorMessage  in
            self.savedCardM = self.savedCardVM.responseStatus
            if let count = self.savedCardM?.count {
                self.savedCardHeight.constant =  CGFloat((count * 100 ) + 5)
            }
            
            self.saveCardTV.reloadData()
            self.saveCardTV.tableFooterView = UIView()
        }
        
    }
    
   private func placeOrder() {
        self.activityIndicator.startAnimating()
        var orders: [[String: Any]] = [[String: Any]]()
    print(tableItems.count)
        for item in tableItems {
            var quality = "low"
            
            var itemID = 0
            itemID = item.value(forKey: "itemID") as? Int ?? 0
            var price = 0.0
            var actualqty = 0
             let isPromotionItem = item.value(forKey: "isPromotionItem") as? Bool ?? false
                if(isPromotionItem){
                    if let actualprice = item.value(forKey: "promotionPrice") as? Double {
                       price = actualprice
                    }
                } else {
                    if(fromVc != "quickbuy") {
                        if(self.getCartQuality(id: itemID) == "M") {
                           quality = "low"
                               if let actualprice = item.value(forKey: "priceLowQuality") as? Double {
                                   price = actualprice
                               }
                           } else {
                               quality = "high"
                               if let actualprice = item.value(forKey: "priceHighQuality") as? Double {
                                   price = actualprice
                               }
                               
                           }
                        actualqty = self.getCartCount(id: itemID) ?? 0
                    } else {
                        for item in BuyagainVC.quickDic {
                         let itemTd =    item["itemID"] as? Int ?? 0
                            if(itemID == itemTd){
                                if let cartCount =  item["cartCount"] as? Int {
                                    if(cartCount > 0) {
                                        actualqty = cartCount
                                        price =  item["price"] as? Double ?? 0.0
                                }
                            }
                        }
                    }
                    }
                }
            
           
             
                
            let item =   [
                "ItemId": item.value(forKey: "itemID") as? Int ?? 0,
                "Weight":  actualqty,
                "PriceQuality": quality,
                "Price": price,
                "Unit":  item.value(forKey: "unit") as? String   ?? ""
            ] as [String : Any]
            orders.append(item)
        }
    print(orders)
        
       var fulladdress =  addressItems[0].value(forKey: "address") as? String ?? ""
            var fulladdressArr = fulladdress.components(separatedBy: ",")
                let area = fulladdressArr[1]
            let  emirate = fulladdressArr[2]
            let shop = fulladdressArr[0]
            let street = shop + "," + area + "," + emirate
            let phone =  addressItems[0].value(forKey: "phone") as? String ?? ""
        var paymentthod = ""
    var payment  = ""
        if(selectedIdex == 0) {
            paymentthod = "COD"
            payment = "CASH ON DELIVERY"
        } else {
            paymentthod = "CAP"
            payment = "CARD PAYMENT"
        }
        
            
        let totalVal = self.total.replacingOccurrences(of: "AED ", with: "", options: [.caseInsensitive, .regularExpression])

        let paramDict =  [
            "Items": orders,
            "GPSCoordinates": addressItems[0].value(forKey: "gps") as? String ?? "" ,
            "DeliveryAddress": shop + "," + area  ,
            "DeliveryName":  addressItems[0].value(forKey: "cname") as? String ?? "" ,
            "DeliveryCity": emirate,
            "DeliveryCountry": "UAE",
            "DeliveryPinCode": "",
            "DeliverySlotTime": self.timeSlote,
            "DeliveryState": emirate,
            "OutletLocationId": UserDefaults.standard.value(forKey: OUTLETID) as? Int ?? 0 ,
            "CustomerId" : UserDefaults.standard.value(forKey: USERID) as? Int ?? 0 ,
            "PaymentMethod": paymentthod ,
            "Payment": payment  ,
            "PhoneNumber": phone,
            "RestaurantId": UserDefaults.standard.value(forKey: RESTAURANTID) as? Int ?? 0 ,
            "Total": totalVal,
            "TransactionID": self.transactionID,
            "AmountPaid": self.amountPaid,
            "CardNumber": self.cardNumber,
            "CardExpiry": self.cardExpiry,
            "CardType": self.cardType,
            "CardTypeID": self.cardTypId
        ] as [String : Any]
     

        self.placeOrderVM.placeOrder(paramDict: paramDict){  isSuccess, errorMessage  in
            if let success = self.placeOrderVM.responseStatus?.message?.lowercased() {
                let date = Date()
                let calendar = Calendar.current
                let components = calendar.dateComponents([.weekday], from: date)
                let dayOfWeek = components.weekday
                    if(success == "success"){
                        self.activityIndicator.stopAnimating()
                        for item in orders {
                            var  qualityShort = "M"
                             let quality = item["PriceQuality"] as? String ?? "M"
                            if(quality == "low"){
                                qualityShort = "M"
                            }else {
                                qualityShort = "H"
                            }
                            self.addToQuickBuy(day: dayOfWeek ?? 1, itemID: item["ItemId"] as? Int ?? 0, qty: item["Weight"] as? Int ?? 0, quality: qualityShort, price: item["Price"] as? Double ?? 0.0  )
                        }
                        if(self.fromVc != "quickbuy") {
                            self.deleteAllData("CartList")
                            UserDefaults.standard.setValue(0, forKey: CARTCOUNT)
                        } else {
                            BuyagainVC.quickDic = []
                        }
                       
                        if let vc =  UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "ThnakyouVC") as? ThnakyouVC {
                            self.navigationController?.pushViewController(vc, animated:   true)
                        }
                    }
                    else {
                        self.showMessageAlert(message: "Somthing went wrong.. Please try again later")
                }
            }
        }
    }
    
    @IBAction func thankyou(_ sender: Any) {
      
       placeOrder()
    }
    
    private func addToQuickBuy(day: Int, itemID: Int, qty: Int, quality : String, price : Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext2 = appDelegate.persistentContainer.viewContext
        var fetchResults: [NSManagedObject]  = []
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "BuyAgain")
        do {
           fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(itemID)")
            fetchResults = try managedContext2.fetch(fetchRequest)
           
            if fetchResults.count != 0 {
             
                fetchResults[0].setValue(day, forKey: "day")
                fetchResults[0].setValue(itemID, forKey: "itemID")
                fetchResults[0].setValue(qty, forKey: "qty")
                fetchResults[0].setValue(quality, forKey: "quality")
                fetchResults[0].setValue(price, forKey: "price")
            try managedContext2.save()
               
            } else {
                let entity =
                  NSEntityDescription.entity(forEntityName: "BuyAgain",
                                             in: managedContext2)!
                let property = NSManagedObject(entity: entity,
                                             insertInto: managedContext2)
                property.setValue(day, forKey: "day")
                property.setValue(itemID, forKey: "itemID")
                property.setValue(qty, forKey: "qty")
                property.setValue(quality, forKey: "quality")
               property.setValue(price, forKey: "price")
                try managedContext2.save()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        
    }
    
    @IBAction func openPaymentPage(_ sender: Any) {
        loadPaymnetPage()
    }
    
    
    @IBAction func paymentModeSelection(_ sender: UIButton) {
        if(sender.tag == 0) {
            selectedIdex = 0
            self.cashOnBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            self.cardOnBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            self.cardListView.isHidden = true
            self.cashonDeliveryView.isHidden = false
            self.webviewOuterView.isHidden = true
            self.webView.isHidden = true
            
            self.savedCardHeight.constant = 680.0
            
        } else {
          
            selectedIdex = 1
            self.cashOnBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            self.cardOnBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            if let count = self.savedCardM?.count {
                if(count > 0) {
                    self.cardListView.isHidden = false
                    self.cashonDeliveryView.isHidden = true
                    if let count = self.savedCardM?.count {
                        self.savedCardHeight.constant =  CGFloat((count * 100 ) + 5)
                    }
                } else {
                    self.cardListView.isHidden = true
                    self.cashonDeliveryView.isHidden = true
                    self.webviewOuterView.isHidden = false
                    self.webView.isHidden = false
                    getPaymentWebView()
                }
            }
        }
    }
    
    private func   getPaymentWebView() {
        
    }
    
    private func getcartList() {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "CartList")
        do {
            let items = try managedContext.fetch(fetchRequest)
            self.tableItems = []
            for item in items {
                if let itemTd =  item.value(forKey: "itemID") as? Int{
                    getProductList(type: itemTd)
                }
            }
           
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func getProductList(type: Int) {
       
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
            fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(type)")
            let items = try managedContext.fetch(fetchRequest)
     
                self.tableItems.append(items[0])
            
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("inside", message.body)
        let jsonString: String =  "\(message.body)"
       
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                
             do {
               let responsemodel = try JSONDecoder().decode(PaymentSuccessModel.self, from:  data)
                transactionID =  responsemodel.transactionID ?? ""
                let decision = responsemodel.decision ?? ""
                if(decision.lowercased() == "accept" && transactionID != "") {
                    self.showMessageAlert(message: "Your payment is successful. Please wait while we process your order...")
                    self.cardNumber = responsemodel.cardNumber ?? ""
                    self.cardExpiry = responsemodel.cardExpiry ?? ""
                    self.cardType = responsemodel.cardType ?? ""
                    self.cardTypId = responsemodel.cardTypeID ?? ""
                let amountPaidString = responsemodel.amountPaid ?? ""
                    self.amountPaid = Double(amountPaidString) ?? 0.0
                   
                    placeOrder()
                }
//                print(transactionID, decision)
             }catch let error{
                 
                 self.showMessageAlert(message: "Please try again. \(error.localizedDescription)")
             }
            } catch {
                print("Something went wrong")
            }
        }
        

    }
    
  
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
       }
       
}

extension PaymentVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedCardM?.count ?? 0
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardTC", for: indexPath) as? SavedCardTC else {
            return UITableViewCell()
        }
        if let id = self.savedCardM?[indexPath.row].cardID {
            cell.cardId = id
        }
        cell.cardNumberLabel.text = self.savedCardM?[indexPath.row].cardNumber ?? ""
        if let expiry = self.savedCardM?[indexPath.row].cardExpiry {
            cell.expiryLabel.text = "Expires: " + expiry
        }
        if let type = self.savedCardM?[indexPath.row].cardType {
            if(type == "Visa") {
                cell.cardImageView.image = UIImage(named: "card_visa")
            }
            if(type == "Mastercard") {
                cell.cardImageView.image = UIImage(named: "card_master")
            }
        }
        if(selectedIndex == indexPath.row) {
            cell.outerView.layer.borderWidth = 3
            cell.outerView.layer.borderColor = AppColor.colorGreen.cgColor
        } else {
            cell.outerView.layer.borderWidth = 1
            cell.outerView.layer.borderColor = UIColor.lightGray.cgColor
        }
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        
            return 100
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        self.selectedIndex = indexPath.row
        guard let cell = saveCardTV.cellForRow(at: indexPath) as? SavedCardTC else {
           return
       }
        selectedCardId = cell.cardId
        neCardView.layer.borderWidth = 1
        neCardView.layer.borderColor = UIColor.lightGray.cgColor
        saveCardTV.reloadData()
        loadPaymnetPage()
    }
}
