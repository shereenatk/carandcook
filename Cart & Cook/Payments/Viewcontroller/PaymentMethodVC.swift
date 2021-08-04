//
//  PaymentMethodVC.swift
//  Cart & Cook
//
//  Created by Development  on 26/07/2021.
//

import Foundation
import UIKit
class PaymentMethodVC: UIViewController {
    
    @IBOutlet weak var cardListTV: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var savedCardVM = SavedCardVM()
    var savedCardM : SavedCardsModel?
    var selectedIdex = 0
    var selectedCardId = 0
    var selectedIndex = -1
    var amount = 0.0
    override func viewDidLoad() {
        getSavedCardLists()
    }
    
    private func getSavedCardLists() {
        savedCardVM.getSavedCards()  { isSuccess, errorMessage  in
            self.activityIndicator.stopAnimating()
            self.savedCardM = self.savedCardVM.responseStatus
            if let coubnt = self.savedCardM?.count {
                self.tableHeight.constant = CGFloat(coubnt * 100)
            }
            self.cardListTV.reloadData()
            self.cardListTV.tableFooterView = UIView()
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
}
extension PaymentMethodVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedCardM?.count ?? 0
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardTC", for: indexPath) as? SavedCardTC else {
            return UITableViewCell()
        }
        if let id = self.savedCardM?[indexPath.row].cardID {
            cell.cardId = id
        }
        cell.cardNumberLabel.text = self.savedCardM?[indexPath.row].cardNumber ?? ""
        if let expiry = self.savedCardM?[indexPath.row].cardExpiry {
            cell.expiryLabel.text = "Expires: " + expiry
        }
        if let type = self.savedCardM?[indexPath.row].cardType {
            if(type == "Visa") {
                cell.cardImageView.image = UIImage(named: "card_visa")
            }
            if(type == "Mastercard") {
                cell.cardImageView.image = UIImage(named: "card_master")
            }
        }
        if(selectedIndex == indexPath.row) {
            cell.outerView.layer.borderWidth = 3
            cell.outerView.layer.borderColor = AppColor.colorGreen.cgColor
        } else {
            cell.outerView.layer.borderWidth = 1
            cell.outerView.layer.borderColor = UIColor.lightGray.cgColor
        }
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        
            return 100
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        self.selectedIndex = indexPath.row
        guard let cell = cardListTV.cellForRow(at: indexPath) as? SavedCardTC else {
           return
       }
        selectedCardId = cell.cardId
        if let vc =  UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "OnlinePaymentVC") as? OnlinePaymentVC {
            vc.selectedCardId = cell.cardId
            vc.totalAmount = self.amount
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
}
