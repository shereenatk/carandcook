//
//  customSOAPrinter.swift
//  Cart & Cook
//
//  Created by Development  on 20/06/2021.
//


import Foundation
import UIKit
class customSOAPrinter: UIPrintPageRenderer {
    
    let A4PageWidth: CGFloat = 595.2
 
    let A4PageHeight: CGFloat = 841.8
    
    override init() {
        super.init()
        self.headerHeight = 50.0
          self.footerHeight = 160.0
     
        // Specify the frame of the A4 page.
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
     
        // Set the page frame.
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
     
        // Set the horizontal and vertical insets (that's optional).
        self.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
        self.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 10.0, dy: 10.0)), forKey: "printableRect")
    }
   
  
   

    override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
     
        let font = UIFont.systemFont(ofSize: 12.0)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let pageNumber = "Page " + "- \(pageIndex + 1) "
        var size = pageNumber.size(withAttributes: attributes)
        let drawX = footerRect.maxX - 50
        let drawY = footerRect.maxY - size.height - 25
        var drawPoint = CGPoint(x: 500, y: drawY)
        
            pageNumber.draw(at: drawPoint, withAttributes: attributes)
       
        
        
    }
 
}
