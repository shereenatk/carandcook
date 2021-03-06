//
//  PreviewPDFViewController.swift
//  Cart & Cook
//
//  Created by Development  on 02/06/2021.
//

import Foundation
import UIKit
import WebKit
import CoreData

class PreviewPDFViewController: UIViewController, UIDocumentInteractionControllerDelegate, WKNavigationDelegate {
    var invoiceComposer: OrderDetailsVC!
    var pdfPath = ""
    var orderListVM = MyOrderVM()
    var orderListM : MyOrderModel?
    var orderId = "0"
    
    @IBOutlet weak var aactivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    @IBOutlet weak var webPreview: WKWebView!
    var HTMLContent: String!
    override func viewDidLoad() {
        pageTitleLabel.text = "INV_" + self.orderId
        
    }
    
    private func getMyOrderList() {
        if let orderInt = Int(orderId) {
            self.orderListVM.getMyOrderList(orderId: orderInt){ isSuccess, errorMessage  in
                self.orderListM = self.orderListVM.responseStatus
                self.orderListM  = self.orderListM?.reversed()
                self.createInvoiceAsHTML()
            }
        }
        
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func createInvoiceAsHTML() {
        invoiceComposer = OrderDetailsVC()
        let invoicedate = self.orderListM?[0].orderDate ?? ""
        
        
          let formatter = DateFormatter()
          formatter.dateFormat = "MMM dd yyyy hh:mma"
          guard let dateVa = formatter.date(from: invoicedate) else {
              return
          }

          formatter.dateFormat = "yyyy"
          let year = formatter.string(from: dateVa)
        let refNum = "#INV-" + "\(year)" + "-" + "\(UserDefaults.standard.value(forKey: USERID) as? Int ?? 0)" + "-" + orderId
        
        if let items = self.orderListM?[0].items{
            var products : [[String: Any]] = [[String: Any]]()
            let subtotal = self.orderListM?[0].total ?? 0.0
            let vat  = subtotal * 0.05
            let total = subtotal + vat
            let  address = self.orderListM?[0].deliveryAddress ?? ""
            let city  =   (self.orderListM?[0].deliveryCity) ?? ""
            let countryaddress =  (self.orderListM?[0].deliveryCountry) ?? ""
            let addressVal = address + "," + city + ","  + countryaddress
            formatter.dateFormat = "MMM dd yyyy hh:mma"
               let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dateVa)
               let dateVal = formatter.string(from: tomorrow!)
           
           

            let timeVal = self.orderListM?[0].deliverySlotTime ?? ""
            let paymnetMetod =  self.orderListM?[0].payment ?? ""
            let phone = self.orderListM?[0].phoneNumber ?? ""
            var i = -1
            for item in items {
                i = i + 1
                if let id = item.itemID {
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
                        fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")
                        let fetchItems = try managedContext.fetch(fetchRequest)
                        let country = fetchItems[0].value(forKey: "country") as? String ?? ""
                        let description =  fetchItems[0].value(forKey: "poductListModelDescription") as? String ?? ""
                        let name = item.name ?? ""
                        let unit = item.unit ?? ""
                        let price = item.price ?? 0.0
                        let qty = item.weight ?? 0.0
                        let singlePrice = price / qty
                        
                        let dict = [ "name" : name, "unit" : unit, "price" : singlePrice, "qty": qty, "total" : price, "country": country, "description" : description, "address" : address] as [String : Any]
                        if(name != "") {
                            products.insert(dict, at: i)
                        }
                       
                       
                    } catch let error as NSError {
                      print("Could not fetch. \(error), \(error.userInfo)")
                    }
//                    print(products, "products")
                    if let invoiceHTML = invoiceComposer.renderInvoice(invoiceNumber: refNum, invoiceDate: invoicedate,
                                                                       items: products,
                                                                       totalAmount: total,
                                                                       subtotal: subtotal,
                                                                       vat: vat,
                                                                       paymentMethod: paymnetMetod,
                                                                       address: addressVal, phone: phone,
                                                                       delDate: dateVal,
                                                                       delTime: timeVal
                                                                       ) {
//                         print(invoiceHTML)
                        if let htmlPathURL = Bundle.main.url(forResource: "invoice", withExtension: "html"){
                                  
            //                           let html = try String(contentsOf: htmlPathURL, encoding: .utf8)
                                        
                                        webPreview.loadHTMLString(invoiceHTML, baseURL:htmlPathURL)
                            aactivityIndicator.stopAnimating()
                            
            //                            HTMLContent = invoiceHTML
            //                invoiceComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
            //                            if #available(iOS 10.0, *) {
            //                                 do {
            //                                     let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            //                                     let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
            //                                     for url in contents {
            //                                         if url.description.contains("invoice1.pdf") {
            //                                            // its your file! do what you want with it!
            //                                          let request = URLRequest(url: url)
            ////                                          self.webPreview.load(request)
            //                                            let dc = UIDocumentInteractionController(url: url)
            //                                                dc.delegate = self
            //                                                dc.presentPreview(animated: true)
            //                                     }
            //                                 }
            //                             } catch {
            //                                 print("could not locate pdf file !!!!!!!")
            //                             }
            //                            }
                                   
                                }
                        
                 
                       
                        
                    }
                   
                }
              
            }
        }
        
      
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyOrderList()
        self.webPreview.translatesAutoresizingMaskIntoConstraints = false
        self.webPreview.navigationDelegate = self
       
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("didFinishNavigation")

        // Sometimes, this delegate is called before the image is loaded. Thus we give it a bit more time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
             pdfPath = invoiceComposer.createPDF(formatter: webView.viewPrintFormatter(), filename: "MyPDFDocument")
            
            print("PDF location: \(pdfPath)")
//            self.pdfFile = path
        }
    }
    
    @IBAction func sharePdf(_ sender: Any) {
        let documento = NSData(contentsOfFile: self.pdfPath)
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
       
    }
    
    @IBAction func viewPdf(_ sender: Any) {
        let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: self.pdfPath))
              viewer.delegate = self

              viewer.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {


        UINavigationBar.appearance().tintColor = UIColor.white

        return self
    }
}
