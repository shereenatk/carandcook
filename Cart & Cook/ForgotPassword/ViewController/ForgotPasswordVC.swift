//
//  ForgotPasswordVC.swift
//  Cart & Cook
//
//  Created by Development  on 30/06/2021.
//

import Foundation
import UIKit
class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var regSuccessView: UIView!
    var forgotPasswordVM = ForgotPasswordVM()
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var custId = 0
    override func viewDidLoad() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.backgroungClick))
        self.backgroundView.addGestureRecognizer(gesture)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "LoginviewControllerVC") as! LoginviewControllerVC
            pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(pvc, animated: true, completion: nil)
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        if let mail = emailTF.text {
            if(mail == "") {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Enter EmailId"
            } else if(!self.isEmailValid(mail)){
                    errorLabel.isHidden = false
                    errorLabel.text = "Enter valid mail id"
                    return
                }
            else {
                self.forgotPasswordVM.forgotPassword( emmail: mail){  isSuccess, errorMessage  in
                    self.backgroundView.isHidden = false
                    self.regSuccessView.isHidden = false
                    if let id = self.forgotPasswordVM.responseStatus?.customerID {
                       print(self.forgotPasswordVM.responseStatus)
                            self.backgroundView.isHidden = false
                            self.regSuccessView.isHidden = false
                            self.custId = id
                        }
                    }
                
            }
            
        }
        
    }
    
    
    @objc func backgroungClick(sender : UITapGestureRecognizer) {
        self.backgroundView.isHidden = true
        self.regSuccessView.isHidden = true
    }
    @IBAction func openOTPPage(_ sender: Any) {
   
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let pvc = storyboard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
        pvc.custId = self.custId
                pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.present(pvc, animated: true, completion: nil)
      
    }
}
