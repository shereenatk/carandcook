//
//  AddSupplierVC.swift
//  Cart & Cook
//
//  Created by Development  on 22/06/2021.
//

import Foundation
import UIKit
import Alamofire
import CountryPickerView
class AddSupplierVC: UIViewController , UITextFieldDelegate , CountryPickerViewDataSource , CountryPickerViewDelegate{
    var selectedCategories  : [String] = []
    var pickerData : [[String:String]] = []
    let pickerController = UIImagePickerController()
    let pickerControllerTradeLicence = UIImagePickerController()
    let pickerControllerContract = UIImagePickerController()
    let now = Date()
    let formatter = DateFormatter()
    var selectedIdex = 0
    var selectedBtnVal = 0
   var  photoPathLogo = ""
    var photoPathTrading = ""
    var photoPathContract = ""
    var logoUploadedPath = ""
    var tradUploadedPath = ""
    var contractUploadedPath = ""
    var supplierId = 0
    
    @IBOutlet weak var catBtn: UIButton!
    var supplierCode = ""
    var addOrEditVM = UpdateSupplierVM()
    let pickerView = ToolbarPickerView()
    let Menu = ["Dubai",
                    "Sharjah",
                    "Abu Dhabi",
                    "Ajman",
                    "RAK",
                    "Umm Al Quwain",
                    "Fujairah"
    ]
    @IBOutlet weak var creaditDaysLabel: UITextField!
    @IBOutlet weak var telPhnTF: UITextField!
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var vatTF: UITextField!
    @IBOutlet weak var emirateTF: UITextField!
    @IBOutlet weak var supplierNameTF: UITextField!
    @IBOutlet weak var mobileTf: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!{
        didSet{
            cancelBtn.layer.cornerRadius = 15
            cancelBtn.layer.borderColor = AppColor.colorGreen.value.cgColor
            cancelBtn.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var cashOnBtn: UIButton!{
        didSet{
            cashOnBtn.tag = 0
//            cashOnBtn.layer.cornerRadius = 10
//            cashOnBtn.layer.borderColor = AppColor.borderColor.value.cgColor
//            cashOnBtn.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var creditBtn: UIButton!{
        didSet{
            creditBtn.tag = 1
//            creditBtn.layer.cornerRadius = 10
//            creditBtn.layer.borderColor = AppColor.borderColor.value.cgColor
//            creditBtn.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var pageTitle: UILabel!
    
    @IBOutlet weak var addSupplierBtn: PrimaryroundButton!
    
    @IBOutlet weak var actionview: SquareView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var contractImageView: UIImageView!
    @IBOutlet weak var tradeIImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoBtn: UIButton!{
        didSet{
            logoBtn.layer.cornerRadius = 10
            logoBtn.layer.borderColor = AppColor.borderColor.value.cgColor
            logoBtn.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var logoview: UIView!{
        didSet{
            logoview.layer.cornerRadius = 10
            logoview.layer.borderColor = AppColor.borderColor.value.cgColor
            logoview.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var tradeView: UIView!{
        didSet{
            tradeView.layer.cornerRadius = 10
            tradeView.layer.borderColor = AppColor.borderColor.value.cgColor
            tradeView.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var contractView: UIView!{
        didSet{
            contractView.layer.cornerRadius = 10
            contractView.layer.borderColor = AppColor.borderColor.value.cgColor
            contractView.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var paymentTerms: UIView!{
        didSet{
            paymentTerms.layer.cornerRadius = 10
            paymentTerms.layer.borderColor = AppColor.borderColor.value.cgColor
            paymentTerms.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var contractBtn: UIButton!{
        didSet{
            contractBtn.layer.cornerRadius = 10
            contractBtn.layer.borderColor = AppColor.borderColor.value.cgColor
            contractBtn.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var tradeLicenceBtn: UIButton!{
        didSet{
            tradeLicenceBtn.layer.cornerRadius = 10
            tradeLicenceBtn.layer.borderColor = AppColor.borderColor.value.cgColor
            tradeLicenceBtn.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var catTf: UITextField!
    @IBOutlet weak var addressTextV: UITextView!{
        didSet{
            addressTextV.layer.cornerRadius = 5
            addressTextV.layer.borderColor = AppColor.borderColor.value.cgColor
            addressTextV.layer.borderWidth = 0.5
        }
    }
    
//    let pickerView = ToolbarPickerView()
    var catVM = CategoryListVM()
    var catM : CategoryListModel?
    var fromVc = ""
    var supplierDetails : SupplierListmodelElement?
    let getobjectVM = GetObjectVM()
  
    @IBOutlet weak var numberOfDaysView: UIView!
    
    @IBOutlet weak var additionNotT: UITextField!
    
    @IBOutlet weak var tradeLicnumTf: UITextField!
    
    override func viewDidLoad() {
        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        mobileTf.leftView = cpv
        mobileTf.leftViewMode = .always
        cpv.delegate = self
        cpv.dataSource = self
        getCategoryList()
        pickerController.delegate = self
        pickerControllerContract.delegate = self
        pickerControllerTradeLicence.delegate = self
        setupDelegatesForTextFields()
        setupDelegateForPickerView()
        if(fromVc == "edit" || fromVc == "view"){
            setAllValues()
            if(fromVc == "view") {
                addSupplierBtn.isHidden = true
                cancelBtn.isHidden = true
                supplierNameTF.isUserInteractionEnabled = false
                emirateTF.isUserInteractionEnabled = false
                vatTF.isUserInteractionEnabled = false
                mailTF.isUserInteractionEnabled = false
                mobileTf.isUserInteractionEnabled = false
                addressTextV.isUserInteractionEnabled = false
                catTf.isUserInteractionEnabled = false
                cashOnBtn.isUserInteractionEnabled = false
                creditBtn.isUserInteractionEnabled = false
                additionNotT.isUserInteractionEnabled = false
                tradeLicnumTf.isUserInteractionEnabled = false
                contractBtn.isUserInteractionEnabled = false
                tradeLicenceBtn.isUserInteractionEnabled = false
                creaditDaysLabel.isUserInteractionEnabled = false
                logoBtn.isUserInteractionEnabled = false
                catBtn.isUserInteractionEnabled = false
                telPhnTF.isUserInteractionEnabled = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
       
    }
    
    @IBAction func tapBackgroundAction(_ sender: Any) {
        backView.isHidden = true
        actionview.isHidden = true
    }
    @IBAction func addPhotoActiomn(_ sender: Any) {
        backView.isHidden = false
        actionview.isHidden = false
        selectedBtnVal = 0
    }
    
  
    @IBAction func tradeLicenceAction(_ sender: Any) {
        backView.isHidden = false
        actionview.isHidden = false
        selectedBtnVal = 1
    }
    
    @IBAction func contractSelectAction(_ sender: Any) {
        backView.isHidden = false
        actionview.isHidden = false
        selectedBtnVal = 2
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cameraAction(_ sender: Any) {
        switch self.selectedBtnVal {
        case 0:
            backView.isHidden = true
            actionview.isHidden = true
            pickerController.sourceType = .camera
            present(pickerController, animated: true)
        case 1:
            backView.isHidden = true
            actionview.isHidden = true
            pickerControllerTradeLicence.sourceType = .camera
            present(pickerControllerTradeLicence, animated: true)
        default:
            backView.isHidden = true
            actionview.isHidden = true
            pickerControllerContract.sourceType = .camera
            present(pickerControllerContract, animated: true)
        }
        
    }
    @IBAction func contractImageAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "FullscreenImageVC") as? FullscreenImageVC {
            vc.image = contractImageView.image ?? UIImage()
            self.navigationController?.pushViewController(vc, animated:   false)

        }
        
    }
    
    @IBAction func tradeImageAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "FullscreenImageVC") as? FullscreenImageVC {
            vc.image = tradeIImageView.image ?? UIImage()
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func logoImageView(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "FullscreenImageVC") as? FullscreenImageVC {
            vc.image = logoImageView.image ?? UIImage()
            self.navigationController?.pushViewController(vc, animated:   false)

        }
    }
    
    @IBAction func galary(_ sender: Any) {
        switch self.selectedBtnVal {
        case 0:
            backView.isHidden = true
            actionview.isHidden = true
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true)
        case 1:
            backView.isHidden = true
            actionview.isHidden = true
            pickerControllerTradeLicence.sourceType = .photoLibrary
            present(pickerControllerTradeLicence, animated: true)
        default:
            backView.isHidden = true
            actionview.isHidden = true
            pickerControllerContract.sourceType = .photoLibrary
            present(pickerControllerContract, animated: true)
        }
       
    }
    @IBAction func paymentModeSelection(_ sender: UIButton) {
        if(sender.tag == 0) {
            selectedIdex = 0
            self.cashOnBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            self.creditBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            numberOfDaysView.isHidden = true
            
        } else {
            selectedIdex = 1
            self.cashOnBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            self.creditBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            numberOfDaysView.isHidden = false
            
        }
    }
    
    @IBAction func showCategoryPicker(_ sender: Any) {
        if let items = self.catM {
           
            for item in items {
                let type = item.type ?? ""
                pickerData.append(["value":type, "display":type])
            }
        }
        
        
        MultiPickerDialog().show(title: "Choose Categories",doneButtonTitle:"Done", cancelButtonTitle:"Cancel" ,options: pickerData, selected:  self.selectedCategories) {
                    values -> Void in
                    //print("SELECTED \(value), \(showName)")
                    print("callBack \(values)")
                    var finalText = ""
                    self.selectedCategories.removeAll()
            for i in 0...values.count - 1 {
                        self.selectedCategories.append(values[i]["display"]!)
                        finalText = finalText  + values[i]["display"]! + (i < values.count - 1 ? " , ": "")
                    }
            self.catTf.text = finalText
                }

    }
    
    fileprivate func setAllValues() {
        addSupplierBtn.setTitle("Update Supplier", for: .normal)
        self.supplierNameTF.text = self.supplierDetails?.supplierName ?? ""
        self.pageTitle.text =  self.supplierDetails?.supplierName ?? ""
        self.supplierCode = self.supplierDetails?.supplierCode ?? ""
        self.mailTF.text = self.supplierDetails?.email ?? ""
        self.emirateTF.text = self.supplierDetails?.emirate ?? ""
        self.additionNotT.text =  self.supplierDetails?.notes ?? ""
        if let vat = self.supplierDetails?.vatNumber {
            self.vatTF.text = "\(vat)"
        }
        self.mobileTf.text = self.supplierDetails?.phoneNumber ?? ""
        self.telPhnTF.text = self.supplierDetails?.telephone ?? ""
        self.addressTextV.text = self.supplierDetails?.address ?? ""
        self.catTf.text = self.supplierDetails?.supplyCategory ?? ""
        self.tradeLicnumTf.text = self.supplierDetails?.trnLicenseNo ?? ""
        if let logoPath = self.supplierDetails?.logo {
            getImage(fileNAme: logoPath, type: "logo")
            self.logoUploadedPath = logoPath
        }
        if let tradePath = self.supplierDetails?.trnLicenseFile {
            getImage(fileNAme: tradePath, type: "trade")
            self.tradUploadedPath = tradePath
        }
        if let contractPath = self.supplierDetails?.otherDocuments {
            getImage(fileNAme: contractPath, type: "contract")
            self.contractUploadedPath = contractPath
        }
        let paymentTerm = self.supplierDetails?.paymentTerm ?? ""
        if(paymentTerm.lowercased().contains("credit")) {
            self.selectedIdex = 1
            self.cashOnBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            self.creditBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            numberOfDaysView.isHidden = false
            let fullArr : [String] = paymentTerm.components(separatedBy: ":")
            let lasrPart : String = fullArr[1]
            self.creaditDaysLabel.text = lasrPart
        } else {
            self.selectedIdex = 0
            self.cashOnBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            self.creditBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            numberOfDaysView.isHidden = true
        }
        
    }
    
    func setupDelegatesForTextFields() {
        emirateTF.delegate = self
        emirateTF.inputView = pickerView
        emirateTF.inputAccessoryView = pickerView.toolbar
    }

        func setupDelegateForPickerView() {
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.toolbarDelegate = self
        }
    
    @IBAction func addSupplierAction(_ sender: Any) {
        if let name = supplierNameTF.text {
            if(name == "") {
                errorLabel.isHidden = false
                errorLabel.text = "Enter supplier name"
                return
            }
           
        }
        if let mail = mailTF.text {
            if(mail == "") {
                errorLabel.isHidden = false
                errorLabel.text = "Enter mail id"
                return
            }
            if(!self.isEmailValid(mail)){
                errorLabel.isHidden = false
                errorLabel.text = "Enter valid mail id"
                return
            }
        }
        if let mob = mobileTf.text {
            if(mob == "") {
                errorLabel.isHidden = false
                errorLabel.text = "Enter mobile number"
            }
//            if(!self.isPhoneNoValid(phone: mob)){
//
//                errorLabel.isHidden = false
//                errorLabel.text = "Enter valid phone number"
//                return
//            }
        }
        if(photoPathLogo != "") {
            uploadImages(path: self.photoPathLogo, type: "logo")
        }
        if(photoPathTrading != "") {
            uploadImages(path: self.photoPathTrading, type: "trade")
        }
        if(photoPathContract != "") {
            uploadImages(path: self.photoPathContract, type: "contract")
        }
        AddSupplier()
    }
    
    private func AddSupplier() {
        
        let restId = UserDefaults.standard.value(forKey: RESTAURANTID) as? Int ?? 0
        var paymnetterm = ""
        if(self.selectedIdex == 0) {
            paymnetterm = "Cash on Delivery"
        } else {
            let date = creaditDaysLabel.text ?? ""
            paymnetterm = "Credit :  " + "\(date)" + " Days Days"
        }
    let paramDict =  [
        "RestaurantId": restId,
        "SupplierID": self.supplierId ,
        "SupplierName": self.supplierNameTF.text ?? "" ,
        "SupplierCode":  self.supplierCode ,
        "PhoneNumber": self.mobileTf.text ?? "",
        "Email" : self.mailTF.text ?? "",
        "Emirate": self.emirateTF.text ?? "",
        "Telephone" : self.telPhnTF.text ?? "",
        "Address": self.addressTextV.text ?? "" ,
        "SupplyCategory": self.catTf.text ?? "" ,
        "VATNumber":  self.vatTF.text ?? "" ,
        "TRNLicenseNo": self.tradeLicnumTf.text ?? "",
        "PaymentTerm": paymnetterm,
        "Notes": self.additionNotT.text ?? "",
        "Logo": self.logoUploadedPath ,
        "TRNLicenseFile" : self.tradUploadedPath,
        "OtherDocuments": self.contractUploadedPath

    ] as [String : Any]
 

    self.addOrEditVM.addOrEditSupplier(paramDict: paramDict){  isSuccess, errorMessage  in
        print("aaa", paramDict)
        print(self.addOrEditVM.responseStatus)
        if let success = self.addOrEditVM.responseStatus?.message {
            
            if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierHomeVC") as? SupplierHomeVC {
                UserDefaults.standard.setValue(0, forKey: SUPPLIERID)
                self.navigationController?.pushViewController(vc, animated:   true)
            }
            
        }
    }
    }
    
    fileprivate func uploadImages(path: String, type : String) {
        let formatter1 = DateFormatter()
        formatter1.timeZone = TimeZone.current
        formatter1.dateFormat = "ddMMyyyyHHmmssSSS"
        let dateString1 = formatter1.string(from: now)

        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss-SSS"
        let dateString = formatter.string(from: now)
        let userId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
        let uploadPath = dateString1 + "/" + "\(userId)" + "/"  + "/" + "Supplier" + "/" + dateString + path
        let parameters: Parameters?
        if(type == "logo") {
            self.logoUploadedPath = uploadPath
        }
        if(type == "trade") {
            self.tradUploadedPath = uploadPath
        }
        if(type == "contract") {
            self.contractUploadedPath = uploadPath
        }
        
        parameters = [
            "FileName": uploadPath
        ]
        let headers : HTTPHeaders?
        headers = [
            "accept": "application/json",
        "Content-Type": "application/json"
    ]
        Alamofire.upload(multipartFormData: { (multipart: MultipartFormData) in
            let fileURL = self.getDocumentsDirectory().appendingPathComponent(path)
            multipart.append(fileURL, withName: "File" , fileName: uploadPath, mimeType: "image/.jpg")
           
            for (key, value) in parameters!{
                
                
                
                
                multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)")
            }
        },usingThreshold: UInt64.init(),
           to: AppConstants.getBaseUrl() + "Common/PutObject",
           method: .post,
           headers: headers,
           encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { [self] (progress) in
                    print("Uploading image")
                    
                })
                
               
            upload.responseJSON { response in
                    do {
                         let fileManager = FileManager.default
                        let fileURL = self.getDocumentsDirectory().appendingPathComponent(path)
                        if fileManager.fileExists(atPath: fileURL.path) {
                            try fileManager.removeItem(atPath: fileURL.path)
                            print("File deleted")
                        } else {
                            print("File does not exist")
                        }
                     
                    }
                    catch let error as NSError {
                        print("An error took place: \(error)")
                    }
            }
            case .failure(let encodingError):
                print("err is \(encodingError)")
                    break
                }
            })
    }
    
    
    private func getCategoryList() {
        catVM.getCategoryList(){  isSuccess, errorMessage  in
            if let count = self.catVM.responseStatus?.count {
                if(count > 0){
                    self.catM = self.catVM.responseStatus
                }
            }
        }
    }
    
    private func getImage(fileNAme : String, type: String) {
        getobjectVM.getObjectData(fileNAme: fileNAme) {  isSuccess, errorMessage  in
            if let  byte = self.getobjectVM.responseStatus?.fileBytes {
                var encoded64 = byte
                let remainder = encoded64.count % 4
                if remainder > 0 {
                    encoded64 = encoded64.padding(toLength: encoded64.count + 4 - remainder,
                                                  withPad: "=",
                                                  startingAt: 0)
                }
                let dataDecoded : Data = Data(base64Encoded: encoded64, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded, scale: 0.5)
                if(type == "logo") {
                    self.logoImageView.image = decodedimage
                }
                if(type == "trade") {
                    self.tradeIImageView.image = decodedimage
                }
                if(type == "contract") {
                    self.contractImageView.image = decodedimage
                }

            }
           
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print("code", country)
    }
    
}
extension AddSupplierVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        switch picker {
        case pickerController:
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            var  imageName = UUID().uuidString
            imageName = imageName + ".jpg"
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            self.photoPathLogo.append(imageName)
            if let jpegData = image.jpegData(compressionQuality: 0.5) {
                try? jpegData.write(to: imagePath)
            }
            self.logoImageView.image = image
            picker.dismiss(animated: true)
        case pickerControllerTradeLicence:
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            var  imageName = UUID().uuidString
            imageName = imageName + ".jpg"
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            self.photoPathTrading.append(imageName)
            if let jpegData = image.jpegData(compressionQuality: 0.5) {
                try? jpegData.write(to: imagePath)
            }
          
            self.tradeIImageView.image = image
           
            picker.dismiss(animated: true)
        default:
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            var  imageName = UUID().uuidString
            imageName = imageName + ".jpg"
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            self.photoPathContract.append(imageName)
            if let jpegData = image.jpegData(compressionQuality: 0.5) {
                try? jpegData.write(to: imagePath)
            }
            self.contractImageView.image = image
            picker.dismiss(animated: true)
        }
       
       
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
extension AddSupplierVC : UIPickerViewDelegate, UIPickerViewDataSource {
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
        if emirateTF.isFirstResponder {
            emirateTF.text = self.Menu[row]
        }
    }
    
}
extension AddSupplierVC: ToolbarPickerViewDelegate {

    func didTapDone() {
        self.view.endEditing(true)
    }

    func didTapCancel() {
       self.view.endEditing(true)
    }
}
