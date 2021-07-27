//
//  ContactUsVC.swift
//  Cart & Cook
//
//  Created by Development  on 31/05/2021.
//

import Foundation
import UIKit
import MessageUI
import SafariServices

class ContactUsVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var cardListTV: UITableView!
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func websiteOpen(_ sender: Any) {
        if let url = URL(string: "https://cartandcook.com/") {
               let config = SFSafariViewController.Configuration()
               config.entersReaderIfAvailable = true

               let vc = SFSafariViewController(url: url, configuration: config)
               present(vc, animated: true)
           }
    }
    
    @IBAction func mailAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
              let mail = MFMailComposeViewController()
              mail.mailComposeDelegate = self
              mail.setToRecipients(["support@cartandcook.com"])
              mail.setSubject("Cart and cook ios app  Help Message")
              present(mail, animated: true, completion: nil)
          } else {
              print("Cannot send mail")
              // give feedback to the user
          }
    }
    @IBAction func callphone(_ sender: Any) {
        let phoneNm = "971503438981"
            if let url = NSURL(string: "tel://\(phoneNm)") {
                UIApplication.shared.openURL(url as URL)
            
        }
    }
}
