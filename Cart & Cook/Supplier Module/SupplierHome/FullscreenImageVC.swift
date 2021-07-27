//
//  FullscreenImageVC.swift
//  Cart & Cook
//
//  Created by Development  on 11/07/2021.
//

import Foundation
import UIKit
class FullscreenImageVC: UIViewController {
    var image  = UIImage()
    @IBOutlet weak var fullImageView: UIImageView!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        self.fullImageView.image = self.image
        if(self.image == UIImage()) {
            shareBtn.isHidden = true
        } else {
            shareBtn.isHidden = false
        }
    }
    @IBAction func shareAction(_ sender: Any) {
    
            let textToShare = [ image ]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               
               if let popoverController = activityViewController.popoverPresentationController {
                   popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                   popoverController.sourceView = self.view
                   popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
               }

               self.present(activityViewController, animated: true, completion: nil)
    
           
    }
    
}
