//
//  ViewOrderDetailsVC.swift
//  Cart & Cook
//
//  Created by Development  on 30/06/2021.
//

import Foundation
import UIKit
class ViewOrderDetailsVC: UIViewController {
    var orderListM : SupplierAllOrder?
    var address = ""
    var time = ""
    var addresId = 0
    var fromVc = ""
    var totalamount = 0.0
    var subTotalAmount = 0.0
    var vatamount = 0.0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var attachmentImageView: UIImageView!
  
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var reviewCV: UICollectionView!
    let getobjectVM = GetObjectVM()
    @IBOutlet weak var viewDeliverynoteBtn: UIButton!{
        didSet{
            viewDeliverynoteBtn.layer.cornerRadius = 5
            viewDeliverynoteBtn.layer.borderWidth = 2
            viewDeliverynoteBtn.layer.borderColor = AppColor.colorGreen.cgColor
            viewDeliverynoteBtn.tintColor = AppColor.colorGreen.value
            viewDeliverynoteBtn
                .setTitleColor(AppColor.colorGreen.value, for: .normal)
        }
    }
    @IBOutlet weak var viewInvoiceBtn: UIButton!{
    didSet{
        viewInvoiceBtn.layer.cornerRadius = 5
        viewInvoiceBtn.layer.borderWidth = 2
        viewInvoiceBtn.layer.borderColor = AppColor.colorGreen.cgColor
        viewInvoiceBtn.tintColor = AppColor.colorGreen.value
        viewInvoiceBtn.setTitleColor(AppColor.colorGreen.value, for: .normal)
    }
}

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var suopplierNameLabel: UILabel!
    @IBOutlet weak var ordrIdLabel: UILabel!
    
    @IBOutlet weak var printBtn: UIButton!{
        didSet{
            printBtn.layer.cornerRadius = 5
            printBtn.layer.borderWidth = 2
            printBtn.layer.borderColor = AppColor.colorGreen.cgColor
            printBtn.tintColor = AppColor.colorGreen.value
            printBtn.setTitleColor(AppColor.colorGreen.value, for: .normal)
        }
    }
    
    @IBOutlet weak var paymentBtn: UIButton!{
        didSet{
            paymentBtn.layer.cornerRadius = 5
            paymentBtn.layer.borderWidth = 2
            paymentBtn.layer.borderColor = AppColor.colorGreen.cgColor
            paymentBtn.tintColor = AppColor.colorGreen.value
            paymentBtn.setTitleColor(AppColor.colorGreen.value, for: .normal)
        }
    }
    
    override func viewDidLoad() {
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
        let deliveryNote = self.orderListM?.deliveryNotePath ?? ""
        let paymentNote = self.orderListM?.paymentReceiptPath ?? ""
        if(paymentNote != "") {
           
            self.paymentBtn.isHidden = false
        } else {
            self.paymentBtn.isHidden = true
        }
        if(deliveryNote != "") {
           
            self.viewDeliverynoteBtn.isHidden = false
        } else {
            self.viewDeliverynoteBtn.isHidden = true
        }
        let invoiceNote = self.orderListM?.invoicePath ?? ""
        if(invoiceNote != "") {
           
            self.viewInvoiceBtn.isHidden = false
        } else {
            self.viewInvoiceBtn.isHidden = true
        }
        reviewCV.reloadData()
    }
    
    
    
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            backBtn.layer.cornerRadius = 15
            
        }
    }
    
    @IBAction func printOrder(_ sender: Any) {
        
        guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
            return
        }


        if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "PreviewPurchaseOrderVC") as? PreviewPurchaseOrderVC {
            vc.orderId = self.orderListM?.orderID  ?? 0
            vc.supplierId = self.orderListM?.supplierID ?? 0
            window.pushViewController(vc, animated:   true)
        }
          
    }
    @IBAction func viewInvoice(_ sender: Any) {
        let invoiceNote = self.orderListM?.invoicePath ?? ""
        getImage(fileNAme: invoiceNote)
    }
    
    @IBAction func viewDeliveyNote(_ sender: Any) {
        let deliveryNote = self.orderListM?.deliveryNotePath ?? ""
            getImage(fileNAme: deliveryNote)
    }
    
    @IBAction func viewPaymentReceipt(_ sender: Any) {
        let paymentNote = self.orderListM?.paymentReceiptPath ?? ""
        getImage(fileNAme: paymentNote)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.closeBtn.isHidden = true
        self.attachmentImageView.isHidden = true
        self.backgroundView.isHidden = true
        
    }
    private func getImage(fileNAme : String) {
        self.activityIndicator.startAnimating()
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
                self.activityIndicator.stopAnimating()
//                self.attachmentImageView.image = decodedimage
                if let vc =  UIStoryboard(name: "Supplier", bundle: nil).instantiateViewController(withIdentifier: "FullscreenImageVC") as? FullscreenImageVC {
                    vc.image = decodedimage ?? UIImage()
                    self.navigationController?.pushViewController(vc, animated:   false)

                }
                
                
                
//                self.attachmentImageView.isHidden = false
//                self.backgroundView.isHidden = false
//                self.closeBtn.isHidden = false
            }
           
        }
    }
    
}
extension  ViewOrderDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orderListM?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell =  reviewCV.dequeueReusableCell(withReuseIdentifier: "ReviewCC", for: indexPath) as? ReviewCC else {
               return UICollectionViewCell()
          }
         let unint = self.orderListM?.items?[indexPath.row].unit ?? ""
        
        let actualprice = self.orderListM?.items?[indexPath.row].price ?? 0.0
        cell.priceLabel.text = "AED " +  String(format: "%.2f", ceil(actualprice*100)/100)  + " / " + unint
             
        let itemID = self.orderListM?.items?[indexPath.row].itemID ?? 0
      
        let cartCount = self.orderListM?.items?[indexPath.row].weight ?? 0
            if(cartCount > 0) {
                cell.qtyLabel.isHidden = false
                cell.qtyLabel.text = "Quantity: " + "\(cartCount)"
                let tota = Double(cartCount) * actualprice
                cell.totalLabel.text = "AED " +  String(format: "%.2f", ceil(tota*100)/100)
                
            } else {
                cell.qtyLabel.isHidden = true
            }
       
        cell.nameLabel.text = self.orderListM?.items?[indexPath.row].productName ?? "0"
        return cell
    }
    
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20)

        return CGSize(width: width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

