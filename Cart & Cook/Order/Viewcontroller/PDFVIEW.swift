//
//  PDFVIEW.swift
//  Cart & Cook
//
//  Created by Development  on 02/06/2021.
//

import Foundation
import UIKit
import WebKit
import SimplePDF
class PdfView: UIViewController {
    @IBOutlet weak var pdfWebview: WKWebView!
    let A4paperSize = CGSize(width: 595, height: 842)
    
    
    
    
    override func viewDidLoad() {
        if #available(iOS 10.0, *) {
             do {
                 let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                 let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                 for url in contents {
                     if url.description.contains("file.pdf") {
                        // its your file! do what you want with it!
                      let request = URLRequest(url: url)
                      self.pdfWebview.load(request)
                 }
             }
         } catch {
             print("could not locate pdf file !!!!!!!")
         }

}
        
    }
    
    
//    let pdf = SimplePDF(pageSize: CGSize(width: 595.2, height: 841.8), pageMargin: 20.0)
//    // or define all margins extra
//    let pdf = SimplePDF(pageSize: CGSize(width: 595.2, height: 841.8), pageMarginLeft: 10, pageMarginTop: 50, pageMarginBottom: 40, pageMarginRight: 10)
    
//    override func viewDidLoad() {
//        let font = UIFont.boldSystemFont(ofSize: 25.0)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//        paragraphStyle.firstLineHeadIndent = 5.0
//
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: font,
//            .foregroundColor: UIColor.black,
//            .paragraphStyle: paragraphStyle
//        ]
//
//        let attributedQuote = NSAttributedString(string: "TAX INVOICE", attributes: attributes)
//
//        pdf.addAttributedText(attributedQuote)
//        // Start a horizonal arrangement
//        pdf.beginHorizontalArrangement()
//        pdf.addImage( UIImage(named: "cartcooklogo_new")! )
//        pdf.addLineSpace(60)
//
//
//        let dataArray = [["DATE", "Test2"],["REF NO", "Test4"]]
//        pdf.addTable(2, columnCount: 2, rowHeight: 20.0, columnWidth: 30.0, tableLineWidth: 1.0, font: UIFont.systemFont(ofSize: 5.0), dataArray: dataArray)
//
//
//        // finishe the horizontal arrangement so you can continue vertically
//        pdf.endHorizontalArrangement()
//        let pdfData = pdf.generatePDFdata()
//
//
//
//        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
//                   let pdfNameFromUrl = "YourAppName.pdf"
//                   let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
//                   do {
//                       try pdfData.write(to: actualPath, options: .atomic)
//                       print("pdf successfully saved!")
//                   } catch {
//                       print("Pdf could not be saved")
//                   }
//        if #available(iOS 10.0, *) {
//                   do {
//                       let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                       let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
//                       for url in contents {
//                           if url.description.contains("YourAppName.pdf") {
//                              // its your file! do what you want with it!
//                            let request = URLRequest(url: url)
//                            self.pdfWebview.load(request)
//                       }
//                   }
//               } catch {
//                   print("could not locate pdf file !!!!!!!")
//               }
//
//    }
//
//
//
//
//
//    }
    
//    var fileName = ""
//
//    @IBOutlet weak var webView: WKWebView!

}
