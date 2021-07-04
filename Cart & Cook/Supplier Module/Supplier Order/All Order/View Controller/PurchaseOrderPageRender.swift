//
//  PurchaseOrderPageRender.swift
//  Cart & Cook
//
//  Created by Development  on 28/06/2021.
//

import Foundation
import Foundation
import UIKit
class PurchaseOrderPageRender: UIPrintPageRenderer {
    
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
   
    override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
       
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyy hh:mm a"
        let headerText: NSString  = formatter.string(from: now) as NSString
        headerText.draw(at: CGPoint(x:450, y:10), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),  NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }

   

    override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
        let footerText: NSString = "Powered by Cart and Cook"
        
     
        let font = UIFont.systemFont(ofSize: 12.0)
////        let textSize = getTextSize(text: footerText as String, font: font!)
////
////        let centerX = footerRect.size.width/2 - textSize.width/2
////        let centerY = footerRect.origin.y + self.footerHeight/2 - textSize.height/2
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.lightGray]
//
//        footerText.draw(at: CGPoint(x:150, y:10), withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25.0)])
//
//
//
////        footerText.draw(at: CGPoint(x:20, y:20))
//
////        let lineOffsetX: CGFloat = 20.0
////           let context = UIGraphicsGetCurrentContext()
////        CGContextSetRGBStrokeColor(context!, 205.0/255.0, 205.0/255.0, 205.0/255, 1.0)
////           CGContextMoveToPoint(context, lineOffsetX, footerRect.origin.y)
////           CGContextAddLineToPoint(context, footerRect.size.width - lineOffsetX, footerRect.origin.y)
////           CGContextStrokePath(context)
//
////        CGContext.setStrokeColor(context, UIColor.lightGray)
        
        
        
        
        let pageNumber = "Page " + "- \(pageIndex + 1) "
        var size = pageNumber.size(withAttributes: attributes)
        let drawX = footerRect.maxX - 50
        let drawY = footerRect.maxY - size.height - 25
        var drawPoint = CGPoint(x: drawX, y: drawY)
        
            pageNumber.draw(at: drawPoint, withAttributes: attributes)
       
        
            size = footerText.size(withAttributes: attributes)
//            drawX = footerRect.maxX - size.width - 80
            drawPoint = CGPoint(x: 10, y: drawY - 60 )
            footerText.draw(at: drawPoint, withAttributes: attributes)
        
    }
 
}
