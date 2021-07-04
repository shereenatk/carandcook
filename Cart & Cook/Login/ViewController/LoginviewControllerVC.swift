//
//  LoginviewControllerVC.swift
//  Cart & Cook
//
//  Created by Development  on 19/05/2021.
//

import Foundation
import UIKit
class LoginviewControllerVC: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.layer.cornerRadius = 15
            loginBtn.layer.borderColor = UIColor.white.cgColor
            loginBtn.layer.borderWidth = 3
            loginBtn.layer.masksToBounds = true
            loginBtn.layer.masksToBounds = false
            loginBtn.layer.shadowRadius = 0.5
            loginBtn.layer.shadowOpacity = 0.5
            loginBtn.layer.shadowColor = UIColor.white.cgColor
            loginBtn.layer.shadowOffset = CGSize(width: 0 , height:1)
        }
    }
    @IBOutlet weak var eyeBtn: UIButton!
    
    var iconClick = true
    var loginM: LoginModel?
    var loginVM = LoginVM()
    
    @IBAction func eyeBtnAction(_ sender: Any) {
        if(iconClick == true) {
            passwordTf.isSecureTextEntry = false
            let image = UIImage(named: "view")
            eyeBtn.imageView?.contentMode = .scaleAspectFit
            eyeBtn.setImage(image, for: .normal)
               } else {
                let image = UIImage(named: "private")
                eyeBtn.imageView?.contentMode = .scaleAspectFit
                eyeBtn.setImage(image, for: .normal)
                passwordTf.isSecureTextEntry = true
               }

               iconClick = !iconClick
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
            pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(pvc, animated: true, completion: nil)
           
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
            pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(pvc, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
       
    
           if let pswrd =  passwordTf.text,
              let mail = emailTf.text {
            if(pswrd == "") {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Enter Password"
                
                return
            }
            if(mail == "") {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Enter EmailId"
               
                return
            }
            else if(!self.isEmailValid(mail)){
                    errorLabel.isHidden = false
                    errorLabel.text = "Enter valid mail id"
                    return
            } else {
                self.loginVM.loginUser(email: mail, password: pswrd){  isSuccess, errorMessage  in
                    if let id = self.loginVM.responseStatus?.customerID {
                        if(id > 0) {
                            UserDefaults.standard.set(id, forKey: USERID)
                            UserDefaults.standard.set(true, forKey: ISLOWQUALITY)
                           
                            if let rname = self.loginVM.responseStatus?.restaurants?[0].restaurantName {
                                UserDefaults.standard.set(rname, forKey: RESTAURANTNAME)
                            }
                            
                            if let fname = self.loginVM.responseStatus?.firstName {
                                UserDefaults.standard.set(fname, forKey: FIRSTNAME)
                            }
                            if let lname = self.loginVM.responseStatus?.lastName {
                                UserDefaults.standard.set(lname, forKey: LASTNAME)
                            }
                            if let mob = self.loginVM.responseStatus?.phoneNumber {
                                UserDefaults.standard.set(mob, forKey: PHONENUMBER)
                            }
                            if let mail = self.loginVM.responseStatus?.emailAddress {
                                UserDefaults.standard.set(mail, forKey: EMAILID)
                            }
                            if let outletId = self.loginVM.responseStatus?.restaurants?[0].outlets?[0].outletLocationID {
                                UserDefaults.standard.set(outletId, forKey: OUTLETID)
                            }
                            if let outletLoc = self.loginVM.responseStatus?.restaurants?[0].outlets?[0].outletLocationName {
                                UserDefaults.standard.set(outletLoc, forKey: OUTLETLOCATION)
                            }
                            if let vat = self.loginVM.responseStatus?.restaurants?[0].vatNumber {
                                UserDefaults.standard.set(vat, forKey: TRNNUMBER)
                            }
                            if let restaurantId = self.loginVM.responseStatus?.restaurants?[0].restaurantID{
                                UserDefaults.standard.set(restaurantId, forKey: RESTAURANTID)
                            }
                            if let brand = self.loginVM.responseStatus?.restaurants?[0].brand{
                                UserDefaults.standard.set(brand, forKey: BRAND)
                            }
                            if let isactive = self.loginVM.responseStatus?.isActive {
                                if(isactive){
                                    UserDefaults.standard.setValue(true, forKey: ISACTIVATEDACCOUNT)
                                    self.errorLabel.isHidden = true
                                    UserDefaults.standard.set(true, forKey: IS_LOGIN)
                                    

                                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                                        let pvc = storyboard.instantiateViewController(withIdentifier: "AppLandingNC") as! AppLandingNC
                                        pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                        self.present(pvc, animated: true, completion: nil)
                                }
                                else if let isincurect = self.loginVM.responseStatus?.isIncorrect {
                                        if(isincurect){
                                            self.activityIndicator.stopAnimating()
                                            self.errorLabel.isHidden = false
                                            self.errorLabel.text = "Wrong credentials"
                                           
                                            return
                                        }
                                        else {
                                            self.errorLabel.isHidden = true
                                            UserDefaults.standard.setValue(false, forKey: ISACTIVATEDACCOUNT)
                                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                                                let pvc = storyboard.instantiateViewController(withIdentifier: "VerificationPendingVC") as! VerificationPendingVC
                                                pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                                self.present(pvc, animated: true, completion: nil)
                                        }
                                    }
                              
                                   
                            
                        }
                        
                        } else {
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = "Invalid User Credentials"
                        }
                       
                    }
                       
                
                   
                }

            }
            
           
           }
        
        
    }
    
}
extension LoginviewControllerVC : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
//extension LoginviewControllerVC : UITextFieldDelegate {
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let count = textField.text {
//            let cpountInt = Int(count) ?? 0
//            self.updateCartCount(id: textField.tag, count: cpountInt)
//        }
//    }
//}
