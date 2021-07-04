//
//  AddPasswordVc.swift
//  Cart & Cook
//
//  Created by Development  on 20/05/2021.
//

import Foundation
import UIKit
class AddPasswordVc: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var retypePswrdEyeBtn: UIButton!
    @IBOutlet weak var newPswrdBtnEye: UIButton!
    @IBOutlet weak var newPassTF: UITextField!
    @IBOutlet weak var reTypeTF: UITextField!
    
    var iconClickNew = true
    var iconClickReyype = true
    var setMailVM = EmailsetVM()
    var setMailM: EmailSetModel?
    var custId = 0
    
    @IBAction func backAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "LoginviewControllerVC") as! LoginviewControllerVC
            pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(pvc, animated: true, completion: nil)
    }
    
    @IBAction func newPaswrdeyeAction(_ sender: Any) {
        if(iconClickNew == true) {
            self.newPassTF.isSecureTextEntry = false
        
            let image = UIImage(named: "view")
            newPswrdBtnEye.imageView?.contentMode = .scaleAspectFit
            newPswrdBtnEye.setImage(image, for: .normal)
               } else {
                let image = UIImage(named: "private")
                newPswrdBtnEye.imageView?.contentMode = .scaleAspectFit
                newPswrdBtnEye.setImage(image, for: .normal)
                    newPassTF.isSecureTextEntry = true
              
               }

               iconClickNew = !iconClickNew
    }
    
    @IBAction func retypePswrdEyeAction(_ sender: Any) {
        if(iconClickReyype == true) {
            self.reTypeTF.isSecureTextEntry = false
        
            let image = UIImage(named: "view")
            retypePswrdEyeBtn.imageView?.contentMode = .scaleAspectFit
            retypePswrdEyeBtn.setImage(image, for: .normal)
               } else {
                let image = UIImage(named: "private")
                retypePswrdEyeBtn.imageView?.contentMode = .scaleAspectFit
                retypePswrdEyeBtn.setImage(image, for: .normal)
                    reTypeTF.isSecureTextEntry = true
              
               }

               iconClickReyype = !iconClickReyype
    }
    
    @IBAction func setPasswordAction(_ sender: Any) {
        if let password = newPassTF.text ,
           let retypePas = reTypeTF.text {
            if(password == ""){
                self.showMessageAlert(message: "Enter password")
                return
            }
            if(retypePas == ""){
                self.showMessageAlert(message: "Retype password")
                return
            }
            if(password != retypePas) {
                self.showMessageAlert(message: "Passwords not matching")
                return
            } else {
                if(!self.isPasswordValid(password)){
                    self.showMessageAlert(message: "Enter valid password")
                    return
                }
            }
            self.setMailVM.setPassword(custId: self.custId, password: password){  isSuccess, errorMessage  in
                self.activityIndicator.stopAnimating()
                if let success = self.setMailVM.responseStatus??.message {
                    if(success.lowercased() == "success") {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let pvc = storyboard.instantiateViewController(withIdentifier: "LoginviewControllerVC") as! LoginviewControllerVC
                            pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                            self.present(pvc, animated: true, completion: nil)
                    }
                }
               
            }
                
            
        }
        
        
       
        
    }
    
}

extension AddPasswordVc : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
