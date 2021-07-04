////
////  FloatingTextFeild.swift
////  Cart & Cook
////
////  Created by Development  on 19/05/2021.
////
//
//import Foundation
//import MaterialComponents.MaterialTextFields
//
//@IBDesignable
//class FloatingPlaceholderTextField: UIView{
//    
//    private var textInput: MDCTextField!
//    private var controller: MDCTextInputControllerOutlined!
//    private let textColor = AppColor.colorPrimary.value // Dynamic dark & light color created in the assets folder
//    private var placeHolderText = ""
//    private var isPassword = false
//    @IBInspectable var setPlaceholder: String{
//        get{
//            return placeHolderText
//        }
//        set(str){
//            placeHolderText = str
//        }
//    }
//    
//    @IBInspectable var setPasswordMode: Bool{
//        get{
//            return isPassword
//        }
//        set(str){
//            isPassword = str
//            setupInputView()
//        }
//    }
//    
//    override func layoutSubviews() {
//       
//        setupInputView()
//        setupContoller()
//           
//    }
//    
//    private func setupInputView(){
//        //MARK: Text Input Setup
//        
//        if let _ = self.viewWithTag(1){return}
//        
//        textInput = MDCTextField()
//        
//        textInput.tag = 1
//        
//        textInput.translatesAutoresizingMaskIntoConstraints = false
//               
//        self.addSubview(textInput)
//        
//        textInput.placeholder = placeHolderText
//        textInput.clearButtonMode = .never
//        textInput.isSecureTextEntry = isPassword
//        textInput.delegate = self
//        
//        textInput.textColor = textColor
//        
//        NSLayoutConstraint.activate([
//            (textInput.topAnchor.constraint(equalTo: self.topAnchor)),
//            (textInput.bottomAnchor.constraint(equalTo: self.bottomAnchor)),
//            (textInput.leadingAnchor.constraint(equalTo: self.leadingAnchor)),
//            (textInput.trailingAnchor.constraint(equalTo: self.trailingAnchor))
//        ])
//    }
//    
//    private func setupContoller(){
//        // MARK: Text Input Controller Setup
//        
//        controller = MDCTextInputControllerOutlined(textInput: textInput)
//        
//        controller.activeColor = textColor
//        controller.normalColor = textColor
//        controller.textInput?.textColor = textColor
//        controller.inlinePlaceholderColor = textColor
//        controller.floatingPlaceholderActiveColor = textColor
//        controller.floatingPlaceholderNormalColor = textColor
//        
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//    }
//    
//}
//
//extension FloatingPlaceholderTextField: UITextFieldDelegate {
//    
//}
