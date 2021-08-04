//
//  MyWalletVC.swift
//  Cart & Cook
//
//  Created by Development  on 27/07/2021.
//

import Foundation
import UIKit
class MyWalletVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var paymentViewHeadingLabel: UILabel!
    @IBOutlet weak var paymentView: SquareImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var addMoneyBtn: PrimaryroundButton!
    @IBOutlet weak var paymnetCatLabel: UILabel!
    @IBOutlet weak var walletImageView: UIImageView!
    @IBOutlet weak var balanceInfoLabel: UILabel!
    @IBOutlet weak var prepaidTf: UITextField!
    
    @IBOutlet weak var payBtn1: UIButton!{
        didSet{
            payBtn1.layer.borderWidth = 1
            payBtn1.layer.borderColor = AppColor.priceBorderColor.cgColor
            payBtn1.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var payBtn2: UIButton!{
        didSet{
            payBtn2.layer.borderWidth = 1
            payBtn2.layer.borderColor = AppColor.priceBorderColor.cgColor
            payBtn2.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var paybtn3: UIButton!{
        didSet{
            paybtn3.layer.borderWidth = 1
            paybtn3.layer.borderColor = AppColor.priceBorderColor.cgColor
            paybtn3.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var textView: UIView!{
        didSet{
            textView.layer.borderWidth = 1
            textView.layer.cornerRadius = 10
        }
    }
    var     outstanding = 0.0
    var prepaidAmount = 0.0
    
    override func viewDidLoad() {
       
        let overDueVM = OverDueVM()
      
        overDueVM.getOverDueAmount(){  isSuccess, errorMessage  in
            self.activityIndicator.stopAnimating()
            self.outstanding = overDueVM.responseStatus?.OutstandingAmount ?? 0.0
            self.prepaidAmount = overDueVM.responseStatus?.PrepaidAmount ?? 0.0
            if(self.outstanding > self.prepaidAmount) {
                self.balanceInfoLabel.text = "Outstanding Amount"
                self.balanceLabel.text = "AED " + "\(self.outstanding)"
                self.walletImageView.image = UIImage(named: "wallet_outstaing")
                self.paymnetCatLabel.text = "Your Outstanding Amount"
                self.balanceLabel.textColor = UIColor.red
                self.addMoneyBtn.setTitle("Pay Outstanding Amount", for: .normal)
                self.paymentViewHeadingLabel.text = "Pay Outstanding Amount"
                self.payBtn1.setTitle("PAY AED " + "\(self.outstanding)", for: .normal)
                self.payBtn1.isHidden = false
                self.payBtn2.isHidden = true
                self.paybtn3.isHidden = true
            } else {
                self.balanceInfoLabel.text = "Available Balance"
                self.balanceLabel.text = "AED " + "\(self.prepaidAmount)"
                self.walletImageView.image = UIImage(named: "wallet_prepaied")
                self.paymnetCatLabel.text = "Your Wallaet"
                self.balanceLabel.textColor = AppColor.colorPrice.value
                self.addMoneyBtn.setTitle("Add Money to Wallet", for: .normal)
                self.paymentViewHeadingLabel.text = "Add Money to Wallet"
                self.payBtn1.isHidden = false
                self.payBtn2.isHidden = false
                self.paybtn3.isHidden = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       return true
    }
    
    @IBAction func addWalletAction(_ sender: Any) {
        self.backView.isHidden = false
        self.paymentView.isHidden = false
    }
    
    @IBAction func moneyVal1Btn(_ sender: Any) {
        if(self.outstanding > self.prepaidAmount) {
            prepaidTf.text = "\(self.outstanding)"
        } else {
            prepaidTf.text = "1000"
        }
    }
    
    @IBAction func moneyVal2Btn(_ sender: Any) {
        prepaidTf.text = "500"
        
    }
    
    @IBAction func moneyVal3Btn(_ sender: Any) {
        prepaidTf.text = "100"
    }
    
    @IBAction func touchBackgroundAction(_ sender: Any) {
        self.backView.isHidden = true
        self.paymentView.isHidden = true
    }
    @IBAction func closePoppupview(_ sender: Any) {
        self.backView.isHidden = true
        self.paymentView.isHidden = true
    }
    
    @IBAction func openPaymentGateway(_ sender: Any) {
        if let amount = prepaidTf.text {
            if (amount == "") {
                self.showMessageAlert(message: "Enter amount")
            } else {
                if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "PaymentMethodVC") as? PaymentMethodVC {
                    if let amouint = self.prepaidTf.text {
                        if let amount = Double(amouint) {
                            vc.amount = amount
                        }
                    }
                   
                    self.navigationController?.pushViewController(vc, animated:   true)

                }
            }
        }
        
    }
    
}
