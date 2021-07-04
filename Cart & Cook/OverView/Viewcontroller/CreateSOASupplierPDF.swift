//
//  CreateSOASupplierPDF.swift
//  Cart & Cook
//
//  Created by Development  on 20/06/2021.
//

import Foundation
import UIKit
import WebKit
import CoreData

class CreateSOASupplierPDF: UIViewController, UIDocumentInteractionControllerDelegate, WKNavigationDelegate {
   var startDate = ""
    var endDate = ""
    var type = ""
    var pdfPath = ""
    var soaVM = SOASupplierVM()
    var soaM : SOASupplierModel?
    var invoiceComposer: OverViewVC!
    @IBOutlet weak var aactivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    @IBOutlet weak var webPreview: WKWebView!
    var HTMLContent: String!
    override func viewDidLoad() {
        
    }
    
    private func getSOAList() {
        self.soaVM.getSOASupplierList(startDate: self.startDate, endDate: self.endDate, type: self.type){ isSuccess, errorMessage  in
            self.soaM = self.soaVM.responseStatus
            self.createInvoiceAsHTML()
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func createInvoiceAsHTML() {
        invoiceComposer = OverViewVC()
        let date = Date()
        var products : [[String: Any]] = [[String: Any]]()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let printDate = formatter.string(from: date)
        var subTotal = 0.0
        var vat = 0.0
        var total = 0.0
        var i = -1
        if let items = self.soaM?.result?.supplierExpenseSOA {
            i = i + 1
            let userId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
            for item in items {
                let year = item.year ?? ""
                let orderId = item.orderID ?? 0
                let refNum = "#PO" + "_" + year + "_" + "\(userId)" + "_" + "\(orderId)"
                let date = item.date ?? ""
                let supplkier = item.supplierName ?? ""
                let price = item.subAmount ?? 0.0
                subTotal = subTotal + price
                let vatVal = item.vatAmount ?? 0.0
                let totalVal = item.totalAmount ?? 0.0
                total = totalVal + total
                vat = vatVal + vat
                
                let dict = [ "date" : date, "invoice" : refNum, "supplier": supplkier, "price" : price, ] as [String : Any]
                if(date != "") {
                    products.insert(dict, at: i)
                }
            }
            
        if let soaHTML = invoiceComposer.renderSOASupplierInvoice( printDate: printDate,
                                                           items: products,
                                                           totalAmount: total,
                                                           subtotal: subTotal,
                                                           vat: vat
                                                           ) {
//                         print(invoiceHTML)
            if let htmlPathURL = Bundle.main.url(forResource: "SOASuplier", withExtension: "html"){
                            
                            webPreview.loadHTMLString(soaHTML, baseURL:htmlPathURL)
                aactivityIndicator.stopAnimating()
                       
                    }
                        
                 
                       
                        
                    }
                   
                
              
            }
        
        
      
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSOAList()
        self.webPreview.translatesAutoresizingMaskIntoConstraints = false
        self.webPreview.navigationDelegate = self
       
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("didFinishNavigation")

        // Sometimes, this delegate is called before the image is loaded. Thus we give it a bit more time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
             pdfPath = invoiceComposer.createPDF(formatter: webView.viewPrintFormatter(), filename: "SOAPDFDocument")
            
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
