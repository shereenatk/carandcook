//
//  OTPVC.swift
//  Cart & Cook
//
//  Created by Development  on 19/05/2021.
//

import Foundation
import UIKit
import OTPFieldView
class OTPVC: UIViewController {
    var custId = 0
    var otp = 0
    var otpVM = OTPValidationVM()
    var otpM: OTPValidationModel?
    var otpResendVM = OTPResendVM()
    var otpResendM: OTPResendModel?
    var counter = 30
    var fromVc = ""
    var timer = Timer()
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var otpSuccessView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    @IBOutlet weak var resendAgainLabel: UILabel!
    @IBOutlet weak var resendBtn: UIButton!{
        didSet{
            resendBtn.layer.cornerRadius = 15
            resendBtn.layer.borderColor = UIColor.white.cgColor
            resendBtn.layer.borderWidth = 3
            resendBtn.layer.masksToBounds = true
            resendBtn.layer.masksToBounds = false
            resendBtn.layer.shadowRadius = 0.5
            resendBtn.layer.shadowOpacity = 0.5
            resendBtn.layer.shadowColor = UIColor.white.cgColor
            resendBtn.layer.shadowOffset = CGSize(width: 0 , height:1)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        setupOtpView()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.backgroungClick))
        self.backgroundView.addGestureRecognizer(gesture)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    func setupOtpView(){
            self.otpTextFieldView.fieldsCount = 4
            self.otpTextFieldView.fieldBorderWidth = 1
        self.otpTextFieldView.defaultBorderColor = .lightGray
        self.otpTextFieldView.filledBorderColor = .lightGray
        
        self.otpTextFieldView.cursorColor =  .lightGray
        
            self.otpTextFieldView.displayType = .square
            self.otpTextFieldView.fieldSize = 60
        
            self.otpTextFieldView.separatorSpace = 8
            self.otpTextFieldView.shouldAllowIntermediateEditing = false
            self.otpTextFieldView.delegate = self
            self.otpTextFieldView.initializeUI()
        }
    @IBAction func backAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "LoginviewControllerVC") as! LoginviewControllerVC
            pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(pvc, animated: true, completion: nil)
    }
    
    fileprivate func callVerifyOTPApi() {
        self.otpVM.otpValidate(custId: self.custId, otp: self.otp){  isSuccess, errorMessage  in
            self.activityIndicator.stopAnimating()
            if let isvalid = self.otpVM.responseStatus??.isOTPvalid {
                if(isvalid) {
                    if(self.fromVc == "reset password") {
                        let pvc = self.storyboard?.instantiateViewController(withIdentifier: "AddPasswordVc") as! AddPasswordVc
                        pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        pvc.custId = self.custId
                        self.present(pvc, animated: true, completion: nil)
                    } else {
                        self.backgroundView.isHidden = false
                        self.otpSuccessView.isHidden = false
                    }
                    
                   
                } else {
                    if let message = self.otpVM.responseStatus??.message {
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = message
                    }
                }
            }
        }
        
    }
    
    @objc func backgroungClick(sender : UITapGestureRecognizer) {
        self.backgroundView.isHidden = true
        self.otpSuccessView.isHidden = true
    }
    
    @IBAction func startNpwAction(_ sender: Any) {
        let pvc = storyboard?.instantiateViewController(withIdentifier: "AddPasswordVc") as! AddPasswordVc
        pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pvc.custId = self.custId
        self.present(pvc, animated: true, completion: nil)
    }
    
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
//            print("\(counter) seconds to the end of the world")
            self.resendAgainLabel.text = "Resend angain in : " + "\(counter)" + "Sec"
            counter -= 1
            
        }
        if(counter == 0) {
            counter -= 1
            resendBtn.layer.borderColor = AppColor.colorGreen.cgColor
            resendBtn.backgroundColor = AppColor.colorGreen.value
            resendBtn.layer.shadowColor = AppColor.colorGreen.cgColor
            resendBtn.setTitleColor(.white, for: .normal)
            resendBtn.isUserInteractionEnabled = true
            timer.invalidate()
        }
    }
    
    @IBAction func resendOtpApiCall(_ sender: Any) {
        self.otpResendVM.otpResent(custId: self.custId){  isSuccess, errorMessage  in
            self.activityIndicator.stopAnimating()
          
            self.resendBtn.layer.borderColor = UIColor.lightGray.cgColor
            self.resendBtn.backgroundColor = UIColor.lightGray
            self.resendBtn.layer.shadowColor = UIColor.lightGray.cgColor
            self.resendBtn.setTitleColor(.black, for: .normal)
            self.resendBtn.isUserInteractionEnabled = false
                        self.counter = 30
                        self.errorLabel.isHidden = true
            }
            
    
       
    }
    
}
extension OTPVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
//        self.resendBtn.isUserInteractionEnabled = true
//        self.resendBtn.backgroundColor = AppColor.colorGreen.value
//        self.resendBtn.setTitleColor(.white, for: .normal)
        callVerifyOTPApi()
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        self.otp = Int(otpString) ?? 0
    }
    
    
}
