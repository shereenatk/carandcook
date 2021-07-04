//
//  SAllOrderDetailsVC.swift
//  Cart & Cook
//
//  Created by Development  on 28/06/2021.
//

import Foundation
import UIKit
import WebKit
import Alamofire
class SAllOrderDetailsVC: UIViewController , UIDocumentInteractionControllerDelegate{
    var status = ""
    var toral = ""
    var supplierId = 0
    var HTMLContent: String!
    var orderListM : [SupplierAllItem]!
    var orderDetailsM : SupplierAllOrder?
    let pathToPOHTMLTemplate =  Bundle.main.path(forResource: "PO", ofType: "html")
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var printView: UIView!
    let pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "POLastItem", ofType: "html")
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var trackView: UIView!
 

       var invoiceNumber: String!

       var pdfFilename: String!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var viewDetailsBbtn: UIButton!
    var orderNum = 0
    var dateVal = ""
    @IBOutlet weak var orderNumLabel: UILabel!
    
    @IBOutlet weak var bittenView: UIView!{
        didSet{
            bittenView.layer.borderColor = UIColor.black.cgColor
            bittenView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        orderNumLabel.text = "Order #" + "\(self.orderNum)"
        dateLabel.text = "Date:" + dateVal
        if let status = orderDetailsM?.orderStatus {
            let lowercased = status.lowercased()
            if(lowercased == "delivered") {
                self.confirmView.isHidden = true
            }
        }
    }
    

    
    @IBAction func tapOnBackground(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 public   func createPDF(formatter: UIViewPrintFormatter, filename: String) -> String {
        // From: https://gist.github.com/nyg/b8cd742250826cb1471f
        
        
        
        // 2. Assign print formatter to UIPrintPageRenderer
        let render = PurchaseOrderPageRender()
        render.addPrintFormatter(formatter, startingAtPageAt: 0)
        
        // 3. Assign paperRect and printableRect
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)
        
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        // 4. Create PDF context and draw
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        
        for i in 1...render.numberOfPages {
            
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext()
        
        // 5. Save PDF file
        let path = "\(NSTemporaryDirectory())\(filename).pdf"
        pdfData.write(toFile: path, atomically: true)
        print("open \(path)")
        
        return path
    }
    
    
    func renderInvoice(invoiceNumber: String, invoiceDate: String,  items: [[String: Any]], totalAmount: Double,
                       subtotal: Double,
                       vat: Double,mailsupplier: String, supplierPhone: String,paymentTErms: String, paymentMethod: String, address: String, phone: String, delDate: String, delTime: String, sname: String) -> String! {
                
                self.invoiceNumber = invoiceNumber
             
            
              let num = UserDefaults.standard.value(forKey: PHONENUMBER) as? String  ?? ""
              
             var brand = UserDefaults.standard.value(forKey: BRAND) as? String ?? ""
             brand = "Brand :" + brand
             var rname = UserDefaults.standard.value(forKey: RESTAURANTNAME) as? String ?? ""
             var trn = UserDefaults.standard.value(forKey: TRNNUMBER) as? String ?? ""
             let mail = UserDefaults.standard.value(forKey: EMAILID) as? String ?? ""
             trn = "TRN : " + trn
             rname = "Name : " + rname
                do {
                    // Load the invoice HTML template code into a String variable.
                    var HTMLContent = try String(contentsOfFile: pathToPOHTMLTemplate!)

                    // Replace all the placeholders with real values except for the items.
                    // The logo image.
     //            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)

                    // Invoice number.
                    HTMLContent = HTMLContent.replacingOccurrences(of: "#DELIVERYRNAME#", with: rname)
                 HTMLContent = HTMLContent.replacingOccurrences(of: "#PO_NUMBER#", with: invoiceNumber)
                 HTMLContent = HTMLContent.replacingOccurrences(of: "#SNAME#", with: sname)
                    // Invoice date.
                 HTMLContent = HTMLContent.replacingOccurrences(of: "#SUPEMAIL#", with: mailsupplier)
                    HTMLContent =  HTMLContent.replacingOccurrences(of: "#PO_DATE#", with: invoiceDate)
                   
                    // Due date (we leave it blank by default).
                    HTMLContent =  HTMLContent.replacingOccurrences(of: "#PAYMENT TERMS#", with: paymentTErms)
                    HTMLContent =  HTMLContent.replacingOccurrences(of: "#SupplierPhone#", with: supplierPhone)
                 HTMLContent =  HTMLContent.replacingOccurrences(of: "#EMAILID#", with: mail)
                 HTMLContent =  HTMLContent.replacingOccurrences(of: "#CUSTOMERPHONE#", with: num)
                 HTMLContent =  HTMLContent.replacingOccurrences(of: "#BRAND#", with: brand)
                 HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYPHONE#", with: phone)
                    // Sender info.
                    HTMLContent =  HTMLContent.replacingOccurrences(of: "#VAT#", with: "AED " + String(format: "%.2f", ceil(vat*100)/100))
                 HTMLContent =  HTMLContent.replacingOccurrences(of: "#SUBTOTAL#", with: "AED " + String(format: "%.2f", ceil(subtotal*100)/100))
                 

                    // Total amount.
                    HTMLContent =  HTMLContent.replacingOccurrences(of: "#TOTAL_AMOUNT#", with: "AED " + String(format: "%.2f", ceil(totalAmount*100)/100))

                 // The invoice items will be added by using a loop.
                       var allItems = ""

                       // For all the items except for the last one we'll use the "single_item.html" template.
                       // For the last one we'll use the "last_item.html" template.
                       for i in 0..<items.count  {
                           var itemHTMLContent: String!

                               itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
                        
                         let singlePrice = items[i]["price"] as? Double ?? 0.0
                         let qty = items[i]["qty"] as? Double ?? 0.0
                         let total = items[i]["total"] as? Double ?? 0.0
                          let discription = items[i]["description"] as? String ?? ""
                         itemHTMLContent = itemHTMLContent.replacingOccurrences(of:"#NAME#", with: items[i]["name"] as? String ?? "")
                         itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#UNIT#", with:  items[i]["unit"] as? String ?? "")
                         itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with: String(format: "%.2f", ceil(singlePrice*100)/100) )
                         itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#QTY#", with: "\(qty)" )
                         itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#TOTAL#", with: String(format: "%.2f", ceil(total*100)/100) )

                           allItems += itemHTMLContent
                       }

                       // Set the items.
                 HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)

                       // The HTML code is ready.
                       return HTMLContent

                }
                catch {
                    print("Unable to open and use HTML template files.")
                }

                return nil
        
    }
    
    @IBAction func editOrderDetails(_ sender: Any) {
        dismiss(animated: false, completion: {
            guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
             return
            }
         if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierEditOrderVC") as? SupplierEditOrderVC {
            vc.orderItemListM = self.orderListM
            vc.orderDeyailsM = self.orderDetailsM
            vc.orderId = self.orderNum
             window.pushViewController(vc, animated:   true)

            }
        })
        
    }
    
    @IBAction func buyAgainAction(_ sender: Any) {
        dismiss(animated: false, completion: {
            guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
             return
            }
         if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierEditOrderVC") as? SupplierEditOrderVC {
            vc.orderItemListM = self.orderListM
            vc.orderDeyailsM = self.orderDetailsM
            vc.orderId = 0
             window.pushViewController(vc, animated:   true)

            }
        })
    }
    
    
    
    @IBAction func confirmOrderAction(_ sender: Any) {
        dismiss(animated: true, completion: {
            guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
                return
            }
            if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "ConfirmSupplierOrderVC") as? ConfirmSupplierOrderVC {
                vc.orderListM = self.orderDetailsM
                   
               
                window.pushViewController(vc, animated:   true)
            }
        })
   }
    
    
    @IBAction func cancelOrderAction(_ sender: Any) {
//         let customerId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
//        let urlString = AppConstants.getBaseUrl() + "Order/" + self.orderNum + "/" + "\(customerId)" + "/Cancel"
//
//
//
//        let url = URL(string: urlString)!
//
//        var request = URLRequest(url: url)
//        let userName = AppConstants.authUserName
//        let password = AppConstants.authPassword
//               let credentialData = "\(userName):\(password)".data(using: .utf8)
//               guard let cred = credentialData else { return  }
//               let base64Credentials = cred.base64EncodedData(options: [])
//               guard let base64Date = Data(base64Encoded: base64Credentials) else { return }
////               return ["Authorization": "Basic \(base64Date.base64EncodedString())"]
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("Basic \(base64Date.base64EncodedString())", forHTTPHeaderField: "Authorization")
//
//        Alamofire.request(request).responseJSON {
//            (response) in
//
//            switch response.result {
//
//                       case .success(let json):
//                        self.activityIndicator.startAnimating()
//                           print(json)
////                        self.dismiss(animated: true)
////                        {
////
////
////                            if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
////                                vc.selectedIndex = 4
////                                self.navigationController?.pushViewController(vc, animated:   true)
////
////                            }
////                        }
//                        guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
//                            return
//                        }
//                        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
//                            vc.selectedIndex = 4
//                            window.pushViewController(vc, animated:   true)
//
//                        }
//                       case .failure(let error):
//                        self.showMessageAlert(message: "Something went wrong")
//                       }
//
//        }
    }
    
    
   
    
    @IBAction func viewOrderDetails(_ sender: Any) {
        dismiss(animated: false, completion: {
            guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
                return
            }
            if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "ViewOrderDetailsVC") as? ViewOrderDetailsVC {
             
                vc.orderListM = self.orderDetailsM
                   
               
                window.pushViewController(vc, animated:   true)
            }
        })
       
    }
    
    @IBAction func printPurchaseOrder(_ sender: Any) {
        dismiss(animated: true, completion: {
            guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
                return
            }


            if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "PreviewPurchaseOrderVC") as? PreviewPurchaseOrderVC {
                vc.orderId = Int(self.orderNum) ?? 0
                vc.supplierId = self.supplierId
                window.pushViewController(vc, animated:   true)
            }
               })
       
//        if let invoiceHTML = self.renderInvoice(invoiceNumber: "IN 403",
//                                                           invoiceDate: "24./3/3012",
//                                                           recipientInfo: "#23435",
//                                                           items: [["item1": "234", "item2": "3435"]],
//                                                           totalAmount: "2344") {
//            if let htmlPathURL = Bundle.main.url(forResource: "invoice", withExtension: "html"){
//                        do {
////                            html = try String(contentsOf: htmlPathURL, encoding: .utf8)
//
////                            webPreview.loadHTMLString(invoiceHTML, baseURL:htmlPathURL)
//                            HTMLContent = invoiceHTML
//                            self.exportHTMLContentToPDF(HTMLContent: HTMLContent)
//                            if #available(iOS 10.0, *) {
//                                 do {
//                                     let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                                     let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
//                                     for url in contents {
//                                        if url.description.contains("INV_" + "\(self.orderNum)" + ".pdf") {
//                                            // its your file! do what you want with it!
//                                          let request = URLRequest(url: url)
////                                          self.webPreview.load(request)
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                                let dc = UIDocumentInteractionController(url: url)
//                                                    dc.delegate = self
//                                                    dc.presentPreview(animated: true)
//                                            }
//
//                                     }
//                                 }
//                             } catch {
//                                 print("could not locate pdf file !!!!!!!")
//                             }
//                            }
//                        } catch  {
//                            print("Unable to get the file.")
//                        }
//                    }
//        }
//
    }
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
     
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
     
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
     
        pdfFilename = "\(self.getDocDir())/" + "INV_" + "\(self.orderNum)" + ".pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
     
        print(pdfFilename)
    }
    
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
     
        UIGraphicsBeginPDFContextToData(data, CGRect.zero , nil)
     
        UIGraphicsBeginPDFPage()
     
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
     
        UIGraphicsEndPDFContext()
     
        return data
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self//or use return self.navigationController for fetching app navigation bar colour
    }
}
