//
//  OrderDetailsVC.swift
//  Cart & Cook
//
//  Created by Development  on 02/06/2021.
//

import Foundation
import UIKit
import WebKit
import Alamofire
class OrderDetailsVC: UIViewController , UIDocumentInteractionControllerDelegate{
    var status = ""
    var toral = ""
    var isCancelHidden = true
    var HTMLContent: String!
    let pathToInvoiceHTMLTemplate =  Bundle.main.path(forResource: "invoice", ofType: "html")

    let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item", ofType: "html")

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var printView: UIView!
    let pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last_item", ofType: "html")
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var trackView: UIView!
    let senderInfo = "Cart & Cook Portal<br>TRN : 100300691100003<br>P.O.Box : 48013, Le Solarium Building, <br>Office # 1004, DSO, Dubai, UAE,<br>Email: info@cartandcook.com<br>Web: www.cartandcook.com"

       let dueDate = ""

       let paymentMethod = "Wire Transfer"

       let logoImageURL = "file:///cartandcook.com/Content/img/logo.png"

       var invoiceNumber: String!

       var pdfFilename: String!
    
    @IBOutlet weak var trackBtn: UIButton!
    
    @IBOutlet weak var sendFeedBackBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var viewDetailsBbtn: UIButton!
    @IBOutlet weak var printBtn: UIButton!
    var orderNum = ""
    var dateVal = ""
    
    @IBOutlet weak var cancelOrderview: UIView!
    @IBOutlet weak var orderNumLabel: UILabel!
    
    @IBOutlet weak var bittenView: UIView!{
        didSet{
            bittenView.layer.borderColor = UIColor.black.cgColor
            bittenView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
       
        orderNumLabel.text = "Order #" + self.orderNum
        dateLabel.text = "Date:" + dateVal
        if(self.status == "Delivered") {
            self.confirmView.isHidden = true
            self.viewHeight.constant = 330.0
        } else if(self.status == "Canceled") {
            self.trackView.isHidden = true
            self.printView.isHidden = true
            self.confirmView.isHidden = true
            self.viewHeight.constant = 200.0
            self.cancelOrderview.isHidden = true
        } else {
            if(self.isCancelHidden) {
                self.cancelOrderview.isHidden = true
            } else {
                self.cancelOrderview.isHidden = false
            }
        }
       
        
//        createPDF()
        
      
    }
    
    @IBAction func tapOnBackground(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 public   func createPDF(formatter: UIViewPrintFormatter, filename: String) -> String {
        // From: https://gist.github.com/nyg/b8cd742250826cb1471f
        
        
        
        // 2. Assign print formatter to UIPrintPageRenderer
        let render = CustomPrintPageRenderer()
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
                       vat: Double, paymentMethod: String, address: String, phone: String, delDate: String, delTime: String) -> String! {
        // Store the invoice number for future use.
           self.invoiceNumber = invoiceNumber
        var customerName = ""
        if let fname = UserDefaults.standard.value(forKey: FIRSTNAME) as? String {
          let lname = UserDefaults.standard.value(forKey: LASTNAME) as? String ?? ""
            customerName = fname + " " + lname
            
        }
         let num = UserDefaults.standard.value(forKey: PHONENUMBER) as? String  ?? ""
         
        var brand = UserDefaults.standard.value(forKey: BRAND) as? String ?? ""
        brand = "Brand :" + brand
        var rname = UserDefaults.standard.value(forKey: RESTAURANTNAME) as? String ?? ""
        var trn = UserDefaults.standard.value(forKey: TRNNUMBER) as? String ?? ""
        trn = "TRN : " + trn
        rname = "Restaurant Name : " + rname
           do {
               // Load the invoice HTML template code into a String variable.
               var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)

               // Replace all the placeholders with real values except for the items.
               // The logo image.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)

               // Invoice number.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_NUMBER#", with: invoiceNumber)

               // Invoice date.
               HTMLContent =  HTMLContent.replacingOccurrences(of: "#INVOICE_DATE#", with: invoiceDate)

               // Due date (we leave it blank by default).
               HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYRNAME#", with: rname)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYBRANDNAME#", with: brand)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#CUSTOMERPHONE#", with: num)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#BRAND#", with: brand)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#TRNNUMBER#", with: trn)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#PAYMENTMETHOD#", with: "Payment Method : " + paymentMethod)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYPHONE#", with: phone)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYADDRESS#", with: address)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYDATE#", with: "Delivery Date :" + delDate)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYTIME#", with: "Delivery Time :" + delTime)
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
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#COUNTRY#", with:  items[i]["country"] as? String ?? "")
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#DESCRIPTION#", with: "(" +  discription  + ")")

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
    
    @IBAction func trackOrderDetails(_ sender: Any) {
     
        guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
            return
        }


        if let vc =  UIStoryboard(name: "OrderDetails", bundle: nil).instantiateViewController(withIdentifier: "TrackOrderVC") as? TrackOrderVC {
            window.pushViewController(vc, animated:   true)
        }
    }
    
    @IBAction func confirmOrderAction(_ sender: Any) {
        let customerId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
        let urlString = AppConstants.getBaseUrl() + "Order/" +   self.orderNum + "/" + "\(customerId)" + "/Delivered"

       let url = URL(string: urlString)!

       var request = URLRequest(url: url)
        let userName = AppConstants.authUserName
        let password = AppConstants.authPassword
              let credentialData = "\(userName):\(password)".data(using: .utf8)
              guard let cred = credentialData else { return  }
              let base64Credentials = cred.base64EncodedData(options: [])
              guard let base64Date = Data(base64Encoded: base64Credentials) else { return }
       request.httpMethod = HTTPMethod.post.rawValue
       request.setValue("Basic \(base64Date.base64EncodedString())", forHTTPHeaderField: "Authorization")

       Alamofire.request(request).responseJSON {
           (response) in
           
           switch response.result {

                      case .success(let json):
                       self.activityIndicator.startAnimating()
                          print(json)
                       guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
                           return
                       }
                       if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
                           vc.selectedIndex = 4
                           window.pushViewController(vc, animated:   true)

                       }
                      case .failure(let error):
                       self.showMessageAlert(message: "Something went wrong")
                      }

       }
   }
    
    
    @IBAction func cancelOrderAction(_ sender: Any) {
         let customerId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
        let urlString = AppConstants.getBaseUrl() + "Order/" + self.orderNum + "/" + "\(customerId)" + "/Cancel"
        
        

        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
        let userName = AppConstants.authUserName
        let password = AppConstants.authPassword
               let credentialData = "\(userName):\(password)".data(using: .utf8)
               guard let cred = credentialData else { return  }
               let base64Credentials = cred.base64EncodedData(options: [])
               guard let base64Date = Data(base64Encoded: base64Credentials) else { return }
//               return ["Authorization": "Basic \(base64Date.base64EncodedString())"]
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Basic \(base64Date.base64EncodedString())", forHTTPHeaderField: "Authorization")

        Alamofire.request(request).responseJSON {
            (response) in
            
            switch response.result {

                       case .success(let json):
                        self.activityIndicator.startAnimating()
//                           print(json)
//                        self.dismiss(animated: true)
//                        {
//
//
//                            if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
//                                vc.selectedIndex = 4
//                                self.navigationController?.pushViewController(vc, animated:   true)
//
//                            }
//                        }
                        self.dismiss(animated: true, completion: {
                            guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
                                return
                            }
                            if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
                                vc.selectedIndex = 4
                                window.pushViewController(vc, animated:   false)

                            }
                        })
                       
                       case .failure(let error):
                        self.showMessageAlert(message: "Something went wrong")
                       }

        }
    }
    
    
    @IBAction func sendFeedbackAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "OrderDetails", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SendFeedbackVC") as! SendFeedbackVC
        vc.orderId = self.orderNum
        vc.total = self.toral
        vc.dateVal = self.dateVal
            vc.modalPresentationStyle =
                UIModalPresentationStyle.overCurrentContext
            self.present(vc, animated: true, completion: nil)
    
    }
    
    @IBAction func viewOrderDetails(_ sender: Any) {
        guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
            return
        }
        if let vc =  UIStoryboard(name: "OrderDetails", bundle: nil).instantiateViewController(withIdentifier: "DetailedOrderVC") as? DetailedOrderVC {
            if let id = Int(self.orderNum) {
                vc.orderId = id
            }
           
            window.pushViewController(vc, animated:   true)
        }
    }
    
    @IBAction func printInvoice(_ sender: Any) {
     
        guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
            return
        }


        if let vc =  UIStoryboard(name: "OrderDetails", bundle: nil).instantiateViewController(withIdentifier: "PreviewPDFViewController") as? PreviewPDFViewController {
            vc.orderId = self.orderNum
            window.pushViewController(vc, animated:   true)
        }
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
    
    
//    func createPDF() {
//        let html = """
//<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
//<HTML>
//<HEAD>
//<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
//<TITLE>pdf-html</TITLE>
//<META name="generator" content="BCL easyConverter SDK 5.0.252">
//<STYLE type="text/css">
//
//body {margin-top: 0px;margin-left: 0px;}
//
//#page_1 {position:relative; overflow: hidden;margin: 14px 0px 11px 32px;padding: 0px;border: none;width: 729px;}
//
//#page_1 #p1dimg1 {position:absolute;top:18px;left:0px;z-index:-1;width:133px;height:134px;}
//#page_1 #p1dimg1 #p1img1 {width:133px;height:134px;}
//
//
//
//
//#page_2 {position:relative; overflow: hidden;margin: 16px 0px 11px 0px;padding: 0px;border: none;width: 793px;}
//#page_2 #id2_1 {border:none;margin: 0px 0px 0px 0px;padding: 0px;border:none;width: 793px;overflow: hidden;}
//#page_2 #id2_2 {border:none;margin: 417px 0px 0px 35px;padding: 0px;border:none;width: 724px;overflow: hidden;}
//
//#page_2 #p2dimg1 {position:absolute;top:320px;left:35px;z-index:-1;width:140px;height:1px;font-size: 1px;line-height:nHeight;}
//#page_2 #p2dimg1 #p2img1 {width:140px;height:1px;}
//
//
//
//
//.ft0{font: 1px 'Times';line-height: 16px;}
//.ft1{font: 10px 'Times';color: #404040;line-height: 12px;}
//.ft2{font: 1px 'Times';line-height: 1px;}
//.ft3{font: bold 21px 'Times';line-height: 24px;}
//.ft4{font: bold 15px 'Times';line-height: 17px;}
//.ft5{font: 16px 'Times';line-height: 19px;}
//.ft6{font: bold 16px 'Times';line-height: 19px;}
//.ft7{font: 19px 'Times';line-height: 21px;}
//.ft8{font: 1px 'Times';line-height: 11px;}
//.ft9{font: 15px 'Times';line-height: 14px;}
//.ft10{font: 1px 'Times';line-height: 14px;}
//.ft11{font: 15px 'Times';line-height: 16px;}
//.ft12{font: 15px 'Times';line-height: 15px;}
//.ft13{font: 1px 'Times';line-height: 15px;}
//.ft14{font: bold 19px 'Times';line-height: 22px;}
//.ft15{font: bold 18px 'Times';line-height: 20px;}
//.ft16{font: 1px 'Times';line-height: 7px;}
//.ft17{font: 13px 'Times';color: #404040;line-height: 15px;}
//.ft18{font: 11px 'Times';color: #404040;line-height: 14px;}
//.ft19{font: 16px 'Helvetica';color: #0000ff;line-height: 18px;}
//.ft20{font: 16px 'Helvetica';line-height: 18px;}
//.ft21{font: 16px 'Times';margin-left: 4px;line-height: 19px;}
//
//.p0{text-align: left;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p1{text-align: center;padding-left: 35px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p2{text-align: left;padding-left: 47px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p3{text-align: left;padding-left: 18px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p4{text-align: left;padding-left: 3px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p5{text-align: left;padding-left: 5px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p6{text-align: center;padding-left: 64px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p7{text-align: left;padding-left: 25px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p8{text-align: left;padding-left: 7px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p9{text-align: left;padding-left: 19px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p10{text-align: center;padding-right: 32px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p11{text-align: left;padding-left: 17px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p12{text-align: center;padding-left: 36px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p13{text-align: center;padding-right: 36px;margin-top: 0px;margin-bottom: 0px;white-space: nowrap;}
//.p14{text-align: right;padding-right: 34px;margin-top: 0px;margin-bottom: 0px;}
//.p15{text-align: left;padding-left: 35px;margin-top: 14px;margin-bottom: 0px;}
//.p16{text-align: left;padding-left: 35px;margin-top: 8px;margin-bottom: 0px;}
//.p17{text-align: left;padding-left: 35px;margin-top: 3px;margin-bottom: 0px;}
//.p18{text-align: left;padding-left: 35px;margin-top: 10px;margin-bottom: 0px;}
//.p19{text-align: left;padding-left: 35px;margin-top: 5px;margin-bottom: 0px;}
//.p20{text-align: left;padding-left: 35px;margin-top: 2px;margin-bottom: 0px;}
//.p21{text-align: left;padding-left: 35px;margin-top: 58px;margin-bottom: 0px;}
//.p22{text-align: left;padding-left: 37px;margin-top: 7px;margin-bottom: 0px;}
//.p23{text-align: left;padding-left: 37px;margin-top: 2px;margin-bottom: 0px;}
//.p24{text-align: left;padding-left: 37px;margin-top: 3px;margin-bottom: 0px;}
//.p25{text-align: left;padding-left: 55px;padding-right: 82px;margin-top: 2px;margin-bottom: 0px;text-indent: -18px;}
//.p26{text-align: left;padding-left: 55px;padding-right: 39px;margin-top: 5px;margin-bottom: 0px;text-indent: -18px;}
//.p27{text-align: left;padding-left: 55px;padding-right: 75px;margin-top: 5px;margin-bottom: 0px;text-indent: -18px;}
//
//.td0{padding: 0px;margin: 0px;width: 0px;vertical-align: bottom;}
//.td1{padding: 0px;margin: 0px;width: 272px;vertical-align: bottom;}
//.td2{padding: 0px;margin: 0px;width: 170px;vertical-align: bottom;}
//.td3{padding: 0px;margin: 0px;width: 120px;vertical-align: bottom;}
//.td4{padding: 0px;margin: 0px;width: 35px;vertical-align: bottom;}
//.td5{padding: 0px;margin: 0px;width: 132px;vertical-align: bottom;}
//.td6{padding: 0px;margin: 0px;width: 167px;vertical-align: bottom;}
//.td7{padding: 0px;margin: 0px;width: 287px;vertical-align: bottom;}
//.td8{padding: 0px;margin: 0px;width: 155px;vertical-align: bottom;}
//.td9{border-bottom: #000000 1px solid;padding: 0px;margin: 0px;width: 272px;vertical-align: bottom;}
//.td10{border-bottom: #000000 1px solid;padding: 0px;margin: 0px;width: 170px;vertical-align: bottom;}
//.td11{border-bottom: #000000 1px solid;padding: 0px;margin: 0px;width: 120px;vertical-align: bottom;}
//.td12{border-bottom: #000000 1px solid;padding: 0px;margin: 0px;width: 35px;vertical-align: bottom;}
//.td13{border-bottom: #000000 1px solid;padding: 0px;margin: 0px;width: 132px;vertical-align: bottom;}
//.td14{padding: 0px;margin: 0px;width: 689px;vertical-align: bottom;}
//
//.tr0{height: 16px;}
//.tr1{height: 32px;}
//.tr2{height: 39px;}
//.tr3{height: 20px;}
//.tr4{height: 75px;}
//.tr5{height: 21px;}
//.tr6{height: 22px;}
//.tr7{height: 48px;}
//.tr8{height: 26px;}
//.tr9{height: 36px;}
//.tr10{height: 10px;}
//.tr11{height: 11px;}
//.tr12{height: 28px;}
//.tr13{height: 14px;}
//.tr14{height: 37px;}
//.tr15{height: 15px;}
//.tr16{height: 31px;}
//.tr17{height: 40px;}
//.tr18{height: 7px;}
//.tr19{height: 19px;}
//
//.t0{width: 729px;font: 16px 'Times';}
//.t1{width: 724px;margin-left: 3px;margin-top: 224px;font: 13px 'Times';color: #404040;}
//.t2{width: 724px;font: 13px 'Times';color: #404040;}
//
//</STYLE>
//</HEAD>
//
//<BODY>
//<DIV id="page_1">
//<DIV id="p1dimg1">
//<IMG src="data:image/png;base64,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" id="p1img1"></DIV>
//
//
//<TABLE cellpadding=0 cellspacing=0 class="t0">
//<TR>
//    <TD class="tr0 td0"></TD>
//    <TD class="tr0 td1"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td2"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td3"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td4"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td5"><P class="p1 ft1"><NOBR>02-06-2021</NOBR> 15:41 pm</P></TD>
//</TR>
//<TR>
//    <TD class="tr1 td0"></TD>
//    <TD class="tr1 td1"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr1 td2"><P class="p0 ft3">TAX INVOICE</P></TD>
//    <TD class="tr1 td3"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr1 td4"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr1 td5"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr2 td0"></TD>
//    <TD class="tr2 td1"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr2 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr2 td3"><P class="p2 ft4">DATE</P></TD>
//    <TD colspan=2 class="tr2 td6"><P class="p3 ft4">Jun 1 2021 10:57AM</P></TD>
//</TR>
//<TR>
//    <TD class="tr3 td0"></TD>
//    <TD class="tr3 td1"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr3 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr3 td3"><P class="p2 ft4">REF NO</P></TD>
//    <TD colspan=2 class="tr3 td6"><P class="p3 ft4"><NOBR>#INV-2021-12-119</NOBR></P></TD>
//</TR>
//<TR>
//    <TD class="tr4 td0"></TD>
//    <TD class="tr4 td1"><P class="p4 ft5">Cart & Cook Portal</P></TD>
//    <TD class="tr4 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD colspan=3 class="tr4 td7"><P class="p2 ft6">Customer Contact</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td0"></TD>
//    <TD class="tr5 td1"><P class="p4 ft5">TRN : 100300691100003</P></TD>
//    <TD class="tr5 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD colspan=2 class="tr5 td8"><P class="p2 ft5">Vaishali Vaishal</P></TD>
//    <TD class="tr5 td5"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td0"></TD>
//    <TD class="tr5 td1"><P class="p4 ft5">P.O.Box : 48013, Le Solarium Building,</P></TD>
//    <TD class="tr5 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD colspan=2 class="tr5 td8"><P class="p2 ft5">971507894561</P></TD>
//    <TD class="tr5 td5"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr6 td0"></TD>
//    <TD class="tr6 td1"><P class="p4 ft5">Office # 1004, DSO, Dubai, UAE.</P></TD>
//    <TD class="tr6 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD colspan=3 class="tr6 td7"><P class="p2 ft5">Restaurant Name : Bowli Cafe</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td0"></TD>
//    <TD class="tr5 td1"><P class="p4 ft5">Email: info@cartandcook.com</P></TD>
//    <TD class="tr5 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD colspan=3 class="tr5 td7"><P class="p2 ft5">Brand Name : aaaa</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td0"></TD>
//    <TD class="tr5 td1"><P class="p4 ft5">Web: www.cartandcook.com</P></TD>
//    <TD class="tr5 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD colspan=3 class="tr5 td7"><P class="p2 ft5">TRN : 347564785</P></TD>
//</TR>
//<TR>
//    <TD class="tr7 td0"></TD>
//    <TD class="tr7 td9"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr7 td10"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr7 td11"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr7 td12"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr7 td13"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr8 td0"></TD>
//    <TD rowspan=2 class="tr9 td1"><P class="p5 ft7">Item</P></TD>
//    <TD rowspan=2 class="tr9 td2"><P class="p6 ft7">Unit</P></TD>
//    <TD class="tr8 td3"><P class="p7 ft7">Price</P></TD>
//    <TD rowspan=2 class="tr9 td4"><P class="p8 ft7">Qty</P></TD>
//    <TD class="tr8 td5"><P class="p1 ft7">Amount</P></TD>
//</TR>
//<TR>
//    <TD class="tr10 td0"></TD>
//    <TD rowspan=2 class="tr5 td11"><P class="p9 ft7">(AED)</P></TD>
//    <TD rowspan=2 class="tr5 td13"><P class="p1 ft7">(AED)</P></TD>
//</TR>
//<TR>
//    <TD class="tr11 td0"></TD>
//    <TD class="tr11 td9"><P class="p0 ft8">&nbsp;</P></TD>
//    <TD class="tr11 td10"><P class="p0 ft8">&nbsp;</P></TD>
//    <TD class="tr11 td12"><P class="p0 ft8">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr12 td0"></TD>
//    <TD class="tr12 td1"><P class="p5 ft5">CA2 - APPLE GOLDEN</P></TD>
//    <TD class="tr12 td2"><P class="p6 ft5">BOX</P></TD>
//    <TD class="tr12 td3"><P class="p10 ft5">11.90</P></TD>
//    <TD class="tr12 td4"><P class="p11 ft5">1</P></TD>
//    <TD class="tr12 td5"><P class="p12 ft5">11.90</P></TD>
//</TR>
//<TR>
//    <TD class="tr13 td0"></TD>
//    <TD class="tr13 td1"><P class="p5 ft9">Syria</P></TD>
//    <TD class="tr13 td2"><P class="p0 ft10">&nbsp;</P></TD>
//    <TD class="tr13 td3"><P class="p0 ft10">&nbsp;</P></TD>
//    <TD class="tr13 td4"><P class="p0 ft10">&nbsp;</P></TD>
//    <TD class="tr13 td5"><P class="p0 ft10">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr0 td0"></TD>
//    <TD class="tr0 td1"><P class="p5 ft11">(3KG/BOX)</P></TD>
//    <TD class="tr0 td2"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td3"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td4"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td5"><P class="p0 ft0">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr14 td0"></TD>
//    <TD class="tr14 td1"><P class="p5 ft5">CA226 - testing</P></TD>
//    <TD class="tr14 td2"><P class="p6 ft5">KG</P></TD>
//    <TD class="tr14 td3"><P class="p10 ft5">35.08</P></TD>
//    <TD class="tr14 td4"><P class="p11 ft5">2</P></TD>
//    <TD class="tr14 td5"><P class="p12 ft5">70.15</P></TD>
//</TR>
//<TR>
//    <TD class="tr13 td0"></TD>
//    <TD class="tr13 td1"><P class="p5 ft9">India</P></TD>
//    <TD class="tr13 td2"><P class="p0 ft10">&nbsp;</P></TD>
//    <TD class="tr13 td3"><P class="p0 ft10">&nbsp;</P></TD>
//    <TD class="tr13 td4"><P class="p0 ft10">&nbsp;</P></TD>
//    <TD class="tr13 td5"><P class="p0 ft10">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr0 td0"></TD>
//    <TD class="tr0 td1"><P class="p5 ft11">(fgffdg)</P></TD>
//    <TD class="tr0 td2"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td3"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td4"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td5"><P class="p0 ft0">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr9 td0"></TD>
//    <TD class="tr9 td1"><P class="p5 ft5">CA228 - APPLE GOLDEN</P></TD>
//    <TD class="tr9 td2"><P class="p6 ft5">KG</P></TD>
//    <TD class="tr9 td3"><P class="p10 ft5">3.45</P></TD>
//    <TD class="tr9 td4"><P class="p11 ft5">4</P></TD>
//    <TD class="tr9 td5"><P class="p12 ft5">13.80</P></TD>
//</TR>
//<TR>
//    <TD class="tr15 td0"></TD>
//    <TD class="tr15 td1"><P class="p5 ft12">Armenia</P></TD>
//    <TD class="tr15 td2"><P class="p0 ft13">&nbsp;</P></TD>
//    <TD class="tr15 td3"><P class="p0 ft13">&nbsp;</P></TD>
//    <TD class="tr15 td4"><P class="p0 ft13">&nbsp;</P></TD>
//    <TD class="tr15 td5"><P class="p0 ft13">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr0 td0"></TD>
//    <TD class="tr0 td1"><P class="p5 ft11"><NOBR>(-)</NOBR></P></TD>
//    <TD class="tr0 td2"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td3"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td4"><P class="p0 ft0">&nbsp;</P></TD>
//    <TD class="tr0 td5"><P class="p0 ft0">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr16 td0"></TD>
//    <TD class="tr16 td9"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr16 td10"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr16 td11"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr16 td12"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr16 td13"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr1 td0"></TD>
//    <TD class="tr1 td1"><P class="p5 ft14">SUB TOTAL</P></TD>
//    <TD class="tr1 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr1 td3"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr1 td4"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr1 td5"><P class="p13 ft15">AED 217.78</P></TD>
//</TR>
//<TR>
//    <TD class="tr17 td0"></TD>
//    <TD class="tr17 td1"><P class="p5 ft14">VAT AMOUNT</P></TD>
//    <TD class="tr17 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr17 td3"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr17 td4"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr17 td5"><P class="p13 ft15">AED 10.89</P></TD>
//</TR>
//<TR>
//    <TD class="tr17 td0"></TD>
//    <TD class="tr17 td1"><P class="p5 ft14">TOTAL AMOUNT</P></TD>
//    <TD class="tr17 td2"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr17 td3"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr17 td4"><P class="p0 ft2">&nbsp;</P></TD>
//    <TD class="tr17 td5"><P class="p13 ft15">AED 228.67</P></TD>
//</TR>
//<TR>
//    <TD class="tr18 td0"></TD>
//    <TD class="tr18 td9"><P class="p0 ft16">&nbsp;</P></TD>
//    <TD class="tr18 td10"><P class="p0 ft16">&nbsp;</P></TD>
//    <TD class="tr18 td11"><P class="p0 ft16">&nbsp;</P></TD>
//    <TD class="tr18 td12"><P class="p0 ft16">&nbsp;</P></TD>
//    <TD class="tr18 td13"><P class="p0 ft16">&nbsp;</P></TD>
//</TR>
//</TABLE>
//<TABLE cellpadding=0 cellspacing=0 class="t1">
//<TR>
//    <TD class="tr3 td14"><P class="p0 ft17">Bank Name: ADCB</P></TD>
//    <TD class="tr3 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr19 td14"><P class="p0 ft17">Account Name : Cart and Cook Portal.</P></TD>
//    <TD class="tr19 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td14"><P class="p0 ft17">Account No. 11940626920001</P></TD>
//    <TD class="tr5 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td14"><P class="p0 ft17">IBAN : AE260030011940626920001</P></TD>
//    <TD class="tr5 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr6 td14"><P class="p0 ft17">Swift Code : ADCBAEAA</P></TD>
//    <TD class="tr6 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td14"><P class="p0 ft17">Branch : Business Bay</P></TD>
//    <TD class="tr5 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td14"><P class="p0 ft17">TRN No. : 100457727400003</P></TD>
//    <TD class="tr5 td4"><P class="p0 ft1">Page - 1</P></TD>
//</TR>
//</TABLE>
//</DIV>
//<DIV id="page_2">
//<DIV id="p2dimg1">
//<IMG src= \"dividerImage.png\" id="p2img1"></DIV>
//
//
//<DIV id="id2_1">
//<P class="p14 ft18"><NOBR>02-06-2021</NOBR> 15:41 pm</P>
//<P class="p15 ft6">Delivery Details</P>
//<P class="p16 ft5">Restaurant Name : Bowli Cafe</P>
//<P class="p17 ft5">Brand Name : aaaa</P>
//<P class="p18 ft5">Delivery Address :</P>
//<P class="p19 ft5">9934534,50 Rizal St, CA, UAE,</P>
//<P class="p19 ft5">971507894561</P>
//<P class="p16 ft5">Payment Method : Cash On Delivery</P>
//<P class="p20 ft5">Delivery Date : <NOBR>02-06-2021</NOBR></P>
//<P class="p20 ft5">Delivery Time : 6:30 AM - 12:00 PM</P>
//<P class="p21 ft19"><A href="https://www.cartandcook.com/">Terms & Conditions</A></P>
//<P class="p22 ft5"><SPAN class="ft20">1.</SPAN><SPAN class="ft21">Unit Prices are in AED & VAT excluded.</SPAN></P>
//<P class="p23 ft5"><SPAN class="ft20">2.</SPAN><SPAN class="ft21">Mode of payment is cash upon delivery</SPAN></P>
//<P class="p24 ft5"><SPAN class="ft20">3.</SPAN><SPAN class="ft21">Cart & Cook reserves right to refuse delivery of goods if payment is not made upon delivery.</SPAN></P>
//<P class="p23 ft5"><SPAN class="ft20">4.</SPAN><SPAN class="ft21">Cart & Cook is not liable to make delivery of goods if your company's account have outstanding balance.</SPAN></P>
//<P class="p25 ft5"><SPAN class="ft20">5.</SPAN><SPAN class="ft21">Please ensure to send the feedback within 2 hours of receiving delivery in order to replace the items or refund amount (T & C Applies)</SPAN></P>
//<P class="p26 ft5"><SPAN class="ft20">6.</SPAN><SPAN class="ft21">When market has short of supply of any particular product ordered, in such circumstances the invoice will be readjusted as per the order delivered, and client has no right to demand/claim for such goods.</SPAN></P>
//<P class="p27 ft5"><SPAN class="ft20">7.</SPAN><SPAN class="ft21">Order delivered in box will have variation in weight due to packaging method. No claim is accepted for shortage of material in the packed box.</SPAN></P>
//</DIV>
//<DIV id="id2_2">
//<TABLE cellpadding=0 cellspacing=0 class="t2">
//<TR>
//    <TD class="tr3 td14"><P class="p0 ft17">Bank Name: ADCB</P></TD>
//    <TD class="tr3 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr19 td14"><P class="p0 ft17">Account Name : Cart and Cook Portal.</P></TD>
//    <TD class="tr19 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td14"><P class="p0 ft17">Account No. 11940626920001</P></TD>
//    <TD class="tr5 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td14"><P class="p0 ft17">IBAN : AE260030011940626920001</P></TD>
//    <TD class="tr5 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr6 td14"><P class="p0 ft17">Swift Code : ADCBAEAA</P></TD>
//    <TD class="tr6 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td14"><P class="p0 ft17">Branch : Business Bay</P></TD>
//    <TD class="tr5 td4"><P class="p0 ft2">&nbsp;</P></TD>
//</TR>
//<TR>
//    <TD class="tr5 td14"><P class="p0 ft17">TRN No. : 100457727400003</P></TD>
//    <TD class="tr5 td4"><P class="p0 ft1">Page - 2</P></TD>
//</TR>
//</TABLE>
//</DIV>
//</DIV>
//</BODY>
//</HTML>
//
//
//
//"""
//        let fmt = UIMarkupTextPrintFormatter(markupText: html)
//
//        // 2. Assign print formatter to UIPrintPageRenderer
//
//        let render = UIPrintPageRenderer()
//        render.addPrintFormatter(fmt, startingAtPageAt: 0)
//
//        // 3. Assign paperRect and printableRect
//
//        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
//        let printable = page.insetBy(dx: 0, dy: 0)
//
//        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
//        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
//
//        // 4. Create PDF context and draw
//
//        let pdfData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
//
//        for i in 1...render.numberOfPages {
//            UIGraphicsBeginPDFPage();
//            let bounds = UIGraphicsGetPDFContextBounds()
//            render.drawPage(at: i - 1, in: bounds)
//        }
//
//        UIGraphicsEndPDFContext();
//
//        // 5. Save PDF file
//
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//
//        pdfData.write(toFile: "\(documentsPath)/file.pdf", atomically: true)
//    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self//or use return self.navigationController for fetching app navigation bar colour
    }
}
