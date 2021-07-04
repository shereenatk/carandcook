//
//  ResetPasswordVC.swift
//  Cart & Cook
//
//  Created by Development  on 31/05/2021.
//

import Foundation
import UIKit
class ResetPasswordVC: UIViewController {
    @IBOutlet weak var mailTF: UITextField!
    var iconClick = true
    var resetMailVM = ResetPasswordVM()
    @IBOutlet weak var passwrdTF: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var eyeBtn: UIButton!
    override func viewDidLoad() {
        if let mail = UserDefaults.standard.value(forKey: EMAILID) as? String {
            mailTF.text = mail
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func eyeBtnAction(_ sender: Any) {
        if(iconClick == true) {
            passwrdTF.isSecureTextEntry = false
            let image = UIImage(named: "view")
            eyeBtn.imageView?.contentMode = .scaleAspectFit
            eyeBtn.setImage(image, for: .normal)
               } else {
                let image = UIImage(named: "private")
                eyeBtn.imageView?.contentMode = .scaleAspectFit
                eyeBtn.setImage(image, for: .normal)
                passwrdTF.isSecureTextEntry = true
               }

               iconClick = !iconClick
    }
    
    @IBAction func nextAction(_ sender: Any) {
        view.endEditing(true)
        if let password = passwrdTF.text {
            if(password == "") {
                errorLabel.isHidden = false
                errorLabel.text = "Enter Password"
                
                return
            } else {
                self.resetMailVM.resetPassword( password: password){  isSuccess, errorMessage  in
                    if let incorrect = self.resetMailVM.responseStatus?.isIncorrect {
                        print(self.resetMailVM.responseStatus)
                        if(incorrect) {
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = "Wrong Password"
                            return
                        } else {
                            self.errorLabel.isHidden = true
                            self.backgroundView.isHidden = false
                            self.successView.isHidden = false
                        }
                    }
                   
                }
            }
        }
        
        
    }
    
    @IBAction func openOTPPage(_ sender: Any) {
   
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let pvc = storyboard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
        pvc.custId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
        pvc.fromVc = "reset password"
                pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.present(pvc, animated: true, completion: nil)
      
    }
}
extension ResetPasswordVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
