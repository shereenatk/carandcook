//
//  RegisterVC.swift
//  Cart & Cook
//
//  Created by Development  on 19/05/2021.
//

import Foundation
import UIKit
import CountryPickerView
class RegisterVC: UIViewController,  CountryPickerViewDelegate, CountryPickerViewDataSource{
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var regSuccessView: UIView!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var accpetBtn: UIButton!
    @IBOutlet weak var regBtn: UIButton!{
        didSet{
            regBtn.layer.cornerRadius = 15
            regBtn.layer.borderColor = UIColor.white.cgColor
            regBtn.layer.borderWidth = 3
            regBtn.layer.masksToBounds = true
            regBtn.layer.masksToBounds = false
            regBtn.layer.shadowRadius = 0.5
            regBtn.layer.shadowOpacity = 0.5
            regBtn.layer.shadowColor = UIColor.white.cgColor
            regBtn.layer.shadowOffset = CGSize(width: 0 , height:1)
        }
    }
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var rnameTf: UITextField!
    @IBOutlet weak var rphonetf: UITextField!
    @IBOutlet weak var brandTf: UITextField!
    @IBOutlet weak var outletTF: UITextField!
    @IBOutlet weak var cuisinetf: UITextField!
    @IBOutlet weak var ownerNameTf: UITextField!
    @IBOutlet weak var omailTF: UITextField!
    @IBOutlet weak var mobileTf: UITextField!
    @IBOutlet weak var vatTf: UITextField!
    var custId = 0
    var isAcceptSelected = false
    var regM: RegisterModel?
    var regVM = RegisterViewModel()
    let pickerView = ToolbarPickerView()
    let Menu = ["Indian",
                    "Asian",
                    "Chinese",
                    "Pakistani",
                    "Tai",
                    "Iranian",
                    "Fresh Juice",
                    "Indinesian",
                    "Arabic",
                    "Lebanese",
                    "Mexican",
                    "Beverages",
                    "Fast Food",
                    "Vegetarian",
                    "Egyptian"
    ]
    
    override func viewDidLoad() {
        setTermsandCnditionUI()
        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        mobileTf.leftView = cpv
        mobileTf.leftViewMode = .always
        cpv.delegate = self
        cpv.dataSource = self
        setupDelegateForPickerView()
        setupDelegatesForTextFields()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.backgroungClick))
        self.backgroundView.addGestureRecognizer(gesture)

       
    }
    
    func setupDelegatesForTextFields() {
        cuisinetf.delegate = self
        cuisinetf.inputView = pickerView
        cuisinetf.inputAccessoryView = pickerView.toolbar
    }

        func setupDelegateForPickerView() {
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.toolbarDelegate = self
        }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptBtnAction(_ sender: Any) {
        if(self.isAcceptSelected) {
           
            self.accpetBtn.setImage(UIImage(named:"checkbox"), for: .normal)
            self.isAcceptSelected = false
        } else {
            self.isAcceptSelected = true
            self.accpetBtn.setImage(UIImage(named:"checkboxclicked"), for: .normal)
        }
    }
    
    @IBAction func registerBtnAction(_ sender: Any) {
    
        if let rname = self.rnameTf.text,
           let rphone = self.rphonetf.text,
           let brand = self.brandTf.text,
           let outlet = self.outletTF.text,
           let cuisine = self.cuisinetf.text,
           let vat = self.vatTf.text,
           let owner = self.ownerNameTf.text,
           let oemail = omailTF.text,
           let mob = mobileTf.text {
            if(rname == ""){
                self.showMessageAlert(message: "Please enter restaurant name")
                return
            }
            if(rphone == ""){
                self.showMessageAlert(message: "Please enter restaurant phone")
                return
            }
//            if(!self.isPhoneNoValid(phone: rphone)) {
//                self.showMessageAlert(message: "Please enter valid restaurant phone")
//                return
//            }
//            if(!self.isPhoneNoValid(phone: mob)) {
//                self.showMessageAlert(message: "Please enter valid mobile number")
//                return
//            }
            
            if(mob == ""){
                self.showMessageAlert(message: "Please enter owner mobilenumber")
                return
            }
            if(oemail == ""){
                self.showMessageAlert(message: "Please enter owner mailid")
                return
            }
            if(!self.isEmailValid(oemail)){
                self.showMessageAlert(message: "Please valid owner mailid")
                return
            }
            if(!isAcceptSelected){
                self.showMessageAlert(message: "Please accept terms and conditions")
                return
            }
            if let vatInt = Int(vat) {
                
            } else {
                self.showMessageAlert(message: "Vat should number be digit")
                return
            }
            let vatInt = Int(vat) ?? 0
            self.regVM.registerUser(cuisine: cuisine, outlet:outlet, emmail: oemail, mob: mob, name: owner, rName: rname, rPhone: rphone, brand: brand, vat: vatInt){  isSuccess, errorMessage  in
                if let success = self.regVM.responseStatus?.success {
                    if(success){
                        self.activityIndicator.stopAnimating()
                        self.backgroundView.isHidden = false
                        self.regSuccessView.isHidden = false
                        self.custId = self.regVM.responseStatus?.customerID ?? 0
                    } else {
                        if let message = self.regVM.responseStatus?.message{
                            self.showMessageAlert(message: message)
                        }
                    }
                }
            }
        }
       
    }
    
    fileprivate func setTermsandCnditionUI() {
        let attributedString = NSMutableAttributedString(string: "Agree to our Terms & Conditions. Read more about our policies & standards here.")
        let url = URL(string: "https://www.cartandcook.com")!

        // Set the 'click here' substring to be the link
        attributedString.setAttributes([.link: url], range: NSMakeRange(13, 18))
        attributedString.setAttributes([.link: url], range: NSMakeRange(74, 4))


        self.textView.attributedText = attributedString
        self.textView.isUserInteractionEnabled = true
        self.textView.isEditable = false

        // Set how links should appear: blue and underlined
        self.textView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
   
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print("code", country)
    }
    
    @IBAction func openOTPPage(_ sender: Any) {
   
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let pvc = storyboard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
        pvc.custId = self.custId
                pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.present(pvc, animated: true, completion: nil)
      
    }

    @objc func backgroungClick(sender : UITapGestureRecognizer) {
        self.backgroundView.isHidden = true
        self.regSuccessView.isHidden = true
    }
    
}


extension RegisterVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.Menu.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.Menu[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Check if the textfield isFirstResponder.
        if cuisinetf.isFirstResponder {
            cuisinetf.text = self.Menu[row]
        }
    }
    
}

extension RegisterVC: ToolbarPickerViewDelegate {

    func didTapDone() {
        self.view.endEditing(true)
    }

    func didTapCancel() {
       self.view.endEditing(true)
    }
}
extension RegisterVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.reloadAllComponents()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
