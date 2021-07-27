//
//  PreviewPurchaseOrderVC.swift
//  Cart & Cook
//
//  Created by Development  on 28/06/2021.
//


import Foundation
import UIKit
import WebKit
import CoreData

class PreviewPurchaseOrderVC: UIViewController, UIDocumentInteractionControllerDelegate, WKNavigationDelegate {
    var poComposer: SAllOrderDetailsVC!
    var pdfPath = ""
    var orderListVM = SupplierAllOrderViewModel()
    var orderListM : [SupplierAllOrder]?
    var orderId = 0
    var supplierId = 0
    
    @IBOutlet weak var aactivityIndicator: UIActivityIndicatorView!
    var supllierVM = SupplierViewModel()
    @IBOutlet weak var pageTitleLabel: UILabel!
    var mailISupplier = ""
    var supplierPhone = ""
    var supplierPaymnetTerms = ""
    
    @IBOutlet weak var webPreview: WKWebView!
    var HTMLContent: String!
    override func viewDidLoad() {
        pageTitleLabel.text = "PO_" + "\(self.orderId)"
       
    }
    
    private func getAllMyOrderList() {
     
       
        self.orderListVM.getsupplierOrderList(supplierId: 0, orderId: self.orderId){ isSuccess, errorMessage  in
                self.orderListM = self.orderListVM.responseStatus?.orders
                self.orderListM  = self.orderListM?.reversed()
                self.createPOAsHTML()
            }
      
        
    }
    
    private func getSupplierList() {
        self.supllierVM.getSupplierList(){  isSuccess, errorMessage  in
            if let count =  self.supllierVM.responseStatus?.count {
                if(count > 0) {
                    if let items = self.supllierVM.responseStatus {
                        for item in items {
                            if let id = item.supplierID {
                                if(id == self.supplierId) {
                                    if let mail = item.email,
                                    let paymnetTErms = item.paymentTerm,
                                      let  phone = item.phoneNumber {
                                        self.mailISupplier = mail
                                        self.supplierPaymnetTerms = paymnetTErms
                                        self.supplierPhone = phone
                                        self.getAllMyOrderList()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func createPOAsHTML() {
        poComposer = SAllOrderDetailsVC()
        let podate = self.orderListM?[0].orderDate ?? ""
          let formatter = DateFormatter()
          formatter.dateFormat = "MMM dd yyyy hh:mma"
          guard let dateVa = formatter.date(from: podate) else {
              return
          }

          formatter.dateFormat = "yyyy"
          let year = formatter.string(from: dateVa)
        let refNum = "#PO-" + "\(year)" + "-" + "\(UserDefaults.standard.value(forKey: USERID) as? Int ?? 0)" + "-" + "\(orderId)"
        
        if let items = self.orderListM?[0].items{
            var products : [[String: Any]] = [[String: Any]]()
            let subtotal = self.orderListM?[0].excludedVatAmount ?? 0.0
            let vat  =  self.orderListM?[0].vatAmount ?? 0.0
            let total =  self.orderListM?[0].includedVatAmount ?? 0.0
            let  name = self.orderListM?[0].supplierName ?? ""
           
            var i = -1
            for item in items {
                i = i + 1
//                if let id = item.itemID {
                    
                    let  name = item.productName ?? ""
                    let  unit = item.unit ?? ""
                    let total = item.price ?? 0.0
                    let qty = item.weight ?? 0
                    let singlePrice = total / qty
                    
                    let dict = [ "name" : name, "unit" : unit, "price" : singlePrice, "qty": qty, "total" : total] as [String : Any]
                    if(name != "") {
                        products.insert(dict, at: i)
                    }

//                    guard let appDelegate =
//                      UIApplication.shared.delegate as? AppDelegate else {
//                        return
//                    }
//                    let managedContext =
//                      appDelegate.persistentContainer.viewContext
//                    let fetchRequest =
//                      NSFetchRequest<NSManagedObject>(entityName: "ProductList")
//                    do {
//                        let sort = NSSortDescriptor(key:"item", ascending:true)
//                        fetchRequest.sortDescriptors = [sort]
//                        fetchRequest.predicate = NSPredicate(format: "itemID = %@", "\(id)")
//                        let fetchItems = try managedContext.fetch(fetchRequest)
//                        let country = fetchItems[0].value(forKey: "country") as? String ?? ""
//                        let description =  fetchItems[0].value(forKey: "poductListModelDescription") as? String ?? ""
//

//                    } catch let error as NSError {
//                      print("Could not fetch. \(error), \(error.userInfo)")
//                    }
                    var paymnetTerms = ""
//                    print(products, "products")
                    if( self.supplierPaymnetTerms != "") {
                        paymnetTerms =  self.supplierPaymnetTerms
                    }
                    if let invoiceHTML = poComposer.renderInvoice(invoiceNumber: refNum, invoiceDate: podate,
                                                                       items: products,
                                                                       totalAmount: total,
                                                                       subtotal: subtotal,
                                                                       vat: vat,
                                                                       mailsupplier: self.mailISupplier,
                                                                       supplierPhone : self.supplierPhone,
                                                                       paymentTErms : paymnetTerms,
                                                                       paymentMethod: "paymnetMetod",
                                                                       address: "addressVal", phone: "phone",
                                                                       delDate: "dateVal",
                                                                       delTime: "timeVal",
                                                                       sname: name
                                                                       ) {
                         print(invoiceHTML)
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

//                }

            }
        }
        
      
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSupplierList()
       
        self.webPreview.translatesAutoresizingMaskIntoConstraints = false
        self.webPreview.navigationDelegate = self
       
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("didFinishNavigation")

        // Sometimes, this delegate is called before the image is loaded. Thus we give it a bit more time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
             pdfPath = poComposer.createPDF(formatter: webView.viewPrintFormatter(), filename: "MyPDFDocument")
            
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
