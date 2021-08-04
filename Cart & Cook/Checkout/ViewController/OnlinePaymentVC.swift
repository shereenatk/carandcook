//
//  OnlinePaymentVC.swift
//  Cart & Cook
//
//  Created by Development  on 01/08/2021.
//

import Foundation
import UIKit
import WebKit
class OnlinePaymentVC: UIViewController, WKScriptMessageHandler , WKNavigationDelegate, WKUIDelegate{
    var transactionID = ""
     var   amountPaid  = 0.0
    var cardNumber = ""
    var cardExpiry  = ""
    var cardType = ""
    var cardTypId = ""
    let contentController = WKUserContentController()
    private var webView: WKWebView!
    var totalAmount = 0.0
    var selectedCardId = 0
    var paymnetVM = OnlinePaymentVM()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        let contentController = WKUserContentController()
           contentController.add(self, name: "observer")

           let configuration = WKWebViewConfiguration()
           configuration.userContentController = contentController

           self.webView = WKWebView( frame: CGRect(x: 10, y: 200, width: self.view.bounds.size.width - 30 , height: self.view.bounds.size.height - 30), configuration: configuration)
     
        webView.isUserInteractionEnabled = true
        self.webView.navigationDelegate = self
        webView.isHidden  = true
           self.view.addSubview(self.webView!)
        self.webView.isHidden = false
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        let custometrId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
//        let url = URL(string: "https://cartandcook.com/Payment/ConfirmOrder?TotalAmount=5.25&CustomerID=12&CustomerCardID=10")!
        let url = URL(string: "https://cartandcook.com/Payment/ConfirmOrder/ConfirmOrder?TotalAmount=\(totalAmount)&CustomerCardID=\(self.selectedCardId)&CustomerID=\(custometrId)")!
        webView.load(URLRequest(url: url))
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                   
//                    placePayment()
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
    
    private func placePayment() {
         self.activityIndicator.startAnimating()
       
         let paramDict =  [
             "CustomerId" : UserDefaults.standard.value(forKey: USERID) as? Int ?? 0 ,
             "TransactionID": self.transactionID,
             "AmountPaid": self.amountPaid,
             "CardNumber": self.cardNumber,
             "CardExpiry": self.cardExpiry,
             "CardType": self.cardType,
             "CardTypeID": self.cardTypId
         ] as [String : Any]


         self.paymnetVM.makeOnlinePayment(paramDict: paramDict){  isSuccess, errorMessage  in
            if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MyWalletVC") as? MyWalletVC {
                self.navigationController?.pushViewController(vc, animated:   true)
            }
         }
     }
    
}
