//
//  ConfirmOrderVC.swift
//  Cart & Cook
//
//  Created by Development  on 30/06/2021.
//


import Foundation
import UIKit
import Alamofire
class ConfirmSupplierOrderVC: UIViewController {
    var orderListM : SupplierAllOrder?
    let pickerControllerInvoice = UIImagePickerController()
    let pickerControllerDeliveryNote = UIImagePickerController()
    let pickerControllerPaymentNote = UIImagePickerController()
    var totalamount = 0.0
    var subTotalAmount = 0.0
    var vatamount = 0.0
    var pathDeliveryNote = ""
    var pathInvoice = ""
    var pathPayment = ""
    var confirmSupOrderVM = ConfirmSupplierOrderVM()
    var selectedBtnVal = -1
    let now = Date()
    let formatter = DateFormatter()
    var uplodedInvoicePath = ""
    var uploadedDeliveryPath = ""
    var uploadedPaymentPath = ""
    @IBOutlet weak var actionView: SquareView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var suopplierNameLabel: UILabel!
    @IBOutlet weak var paymentImageView: UIImageView!
    
    @IBOutlet weak var uploadInvoice: UIButton!{
        didSet{
            uploadInvoice.layer.cornerRadius = 10
            uploadInvoice.layer.borderColor = AppColor.borderColor.value.cgColor
            uploadInvoice.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var uploadDeliveryBtn: UIButton!{
        didSet{
            uploadDeliveryBtn.layer.cornerRadius = 10
            uploadDeliveryBtn.layer.borderColor = AppColor.borderColor.value.cgColor
            uploadDeliveryBtn.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var confirmDeliveryBtn: UIButton!{
        didSet{
            confirmDeliveryBtn.layer.cornerRadius = 10
            confirmDeliveryBtn.layer.borderColor = AppColor.borderColor.value.cgColor
            confirmDeliveryBtn.layer.borderWidth = 0.5
        }
    }
    
    
    @IBOutlet weak var uploadPaymentRecieptBtn: UIButton!{
        didSet{
            uploadPaymentRecieptBtn.layer.cornerRadius = 10
            uploadPaymentRecieptBtn.layer.borderColor = AppColor.borderColor.value.cgColor
            uploadPaymentRecieptBtn.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var deliveryNoteImageView: UIImageView!
    @IBOutlet weak var invoiceImageView: UIImageView!
    @IBOutlet weak var ordrIdLabel: UILabel!
    override func viewDidLoad() {
        pickerControllerInvoice.delegate = self
        pickerControllerDeliveryNote.delegate = self
        pickerControllerPaymentNote.delegate = self
        if let id = self.orderListM?.orderID  {
            ordrIdLabel.text = "ID #" + "\(id)"
        }
        if let excluded = self.orderListM?.excludedVatAmount{
            subTotalLabel.text = "AED " +  String(format: "%.2f", ceil(excluded*100)/100)
        }
        if let vat = self.orderListM?.vatAmount {
            vatLabel.text = "AED " +  String(format: "%.2f", ceil(vat*100)/100)
        }
        if let total = self.orderListM?.includedVatAmount {
            totalLabel.text = "AED " +  String(format: "%.2f", ceil(total*100)/100)
        }
        dateLabel.text  = self.orderListM?.orderDate ?? ""
        suopplierNameLabel.text = self.orderListM?.supplierName ?? ""
       
    }
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            backBtn.layer.cornerRadius = 15
            
        }
    }
    
    @IBAction func uploadDeliveryBtnAction(_ sender: Any){ self.actionView.isHidden = false
    self.backView.isHidden = false
    selectedBtnVal = 1
    }
    
    @IBAction func uploadPaymentRecieptAction(_ sender: Any) {
        self.actionView.isHidden = false
        self.backView.isHidden = false
        selectedBtnVal = 2
    }
    
    @IBAction func uploadInvoiceAction(_ sender: Any) {
        self.actionView.isHidden = false
        self.backView.isHidden = false
        selectedBtnVal = 0
    }
    
    @IBAction func clickBackView(_ sender: Any) {
        self.backView.isHidden = true
        self.actionView.isHidden = true
    }
    
    @IBAction func closeInavoiceImageAction(_ sender: Any) {
        self.invoiceImageView.image = UIImage()
    }
    
    @IBAction func closeDeliveryImageAction(_ sender: Any) {
        self.deliveryNoteImageView.image = UIImage()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ConfirmDelivery(_ sender: Any) {
        if(pathInvoice != "") {
            uploadImages(path: self.pathInvoice, type: "invoice")
        }
        if(pathDeliveryNote != "") {
            uploadImages(path: self.pathDeliveryNote, type: "deliverynote")
        }
        if(pathPayment != "") {
            uploadImages(path: self.pathPayment, type: "paymentReciept")
        }
        finalConfirmation()
        
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
        if(type == "invoice") {
            self.uplodedInvoicePath = uploadPath
        }
        if(type == "deliverynote") {
            self.uploadedDeliveryPath = uploadPath
        }
        if(type == "paymentReciept") {
            self.uploadedPaymentPath = uploadPath
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
    
    
    private func finalConfirmation() {
        
        let userId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
        let id = self.orderListM?.orderID   ?? 0
        
    let paramDict =  [
        "OrderId":id,
       "CustomerId": userId,
        "InvoicePath":self.uplodedInvoicePath,
       "DeliveryNotePath": uploadedDeliveryPath,
        "PaymentReceiptPath" : uploadedPaymentPath
    ] as [String : Any]
 

    self.confirmSupOrderVM.supplierConfirmOrder(paramDict: paramDict){  isSuccess, errorMessage  in
       
        print(self.confirmSupOrderVM.responseStatus)
        if let success = self.confirmSupOrderVM.responseStatus?.message {
         let id  = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
            if(id == 0) {
                if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "SupplierAllOrderVC") as? SupplierAllOrderVC {
                    self.navigationController?.pushViewController(vc, animated:   true)
                }
            } else {
                if let vc =  UIStoryboard(name: "SupplierCart", bundle: nil).instantiateViewController(withIdentifier: "SupplierOrderListVC") as? SupplierOrderListVC {
                    vc.supplierId = UserDefaults.standard.value(forKey: SUPPLIERID) as? Int ?? 0
                    self.navigationController?.pushViewController(vc, animated:   true)
                }
            }
                
            
        }
    }
    }
    
    
    @IBAction func cameraAction(_ sender: Any) {
        backView.isHidden = true
        self.actionView.isHidden = true
        
        switch self.selectedBtnVal {
        case 0:
            pickerControllerInvoice.sourceType = .camera
            present(pickerControllerInvoice, animated: true)
        case 1 :
            pickerControllerDeliveryNote.sourceType = .camera
            present(pickerControllerDeliveryNote, animated: true)
        default:
            pickerControllerPaymentNote.sourceType = .camera
            present(pickerControllerPaymentNote, animated: true)
        }
        
    }
    
    @IBAction func galary(_ sender: Any) {
        backView.isHidden = true
        actionView.isHidden = true
       
        switch self.selectedBtnVal {
        case 0:
            pickerControllerInvoice.sourceType = .photoLibrary
            present(pickerControllerInvoice, animated: true)
        case 1:
            pickerControllerDeliveryNote.sourceType = .photoLibrary
            present(pickerControllerDeliveryNote, animated: true)
        default:
            pickerControllerPaymentNote.sourceType = .photoLibrary
            present(pickerControllerPaymentNote, animated: true)
        }
       
    }
    
}
extension ConfirmSupplierOrderVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        switch picker {
        case pickerControllerDeliveryNote:
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            var  imageName = UUID().uuidString
            imageName = imageName + ".jpg"
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            self.pathDeliveryNote.append(imageName)
            if let jpegData = image.jpegData(compressionQuality: 0.5) {
                try? jpegData.write(to: imagePath)
            }
            self.deliveryNoteImageView.image = image
            picker.dismiss(animated: true)
        case pickerControllerInvoice:
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            var  imageName = UUID().uuidString
            imageName = imageName + ".jpg"
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            self.pathInvoice.append(imageName)
            if let jpegData = image.jpegData(compressionQuality: 0.5) {
                try? jpegData.write(to: imagePath)
            }
            self.invoiceImageView.image = image
            picker.dismiss(animated: true)
        default:
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            var  imageName = UUID().uuidString
            imageName = imageName + ".jpg"
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            self.pathPayment.append(imageName)
            if let jpegData = image.jpegData(compressionQuality: 0.5) {
                try? jpegData.write(to: imagePath)
            }
            self.paymentImageView.image = image
            picker.dismiss(animated: true)
        }
       
       
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
