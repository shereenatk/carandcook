//
//  Appcolor.swift
//  Cart & Cook
//
//  Created by Development  on 19/05/2021.
//

import Foundation

import UIKit
import Foundation

extension UIColor {
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {

        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let redMask = Int(color >> 16) & mask
        let greenMask = Int(color >> 8) & mask
        let blueMask = Int(color) & mask
        let red   = CGFloat(redMask) / 255.0
        let green = CGFloat(greenMask) / 255.0
        let blue  = CGFloat(blueMask) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    /**
     Creates an UIColor Object based on provided RGB value in integer
     - parameter red:   Red Value in integer (0-255)
     - parameter green: Green Value in integer (0-255)
     - parameter blue:  Blue Value in integer (0-255)
     - returns: UIColor with specified RGB values
     */
}
enum AppColor {
    case chartClr1 // Yellow theme color of the application
    case chartClr2
    case chartClr3
    case chartClr4
    case chartClr5// Yellow theme color of the application
    case chartClr6
    case chartClr7
    case chartClr8
    case chartClr9// Yellow theme color of the application
    case chartClr10
    case chartClr11
    case chartClr12
    case chartClr13// Yellow theme color of the application
    case chartClr14
    case chartClr15
    case colorPrimary
    case colorPrimaryDark
    case colorGreen
    case chartGreen
    case colorPrice
    case backgroundred
    case borderColor
    case priceBorderColor
 
    // 1
    case custom(hexString: String, alpha: Double)
    // 2
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

extension AppColor {
    var value: UIColor {
        var instanceColor = UIColor.clear
        switch self {
        case .chartGreen:
            instanceColor = UIColor(red: 0.23, green: 0.74, blue: 0.67, alpha: 1.00)
        case .priceBorderColor:
            instanceColor = UIColor(red: 0.91, green: 0.77, blue: 0.57, alpha: 1.00)
        case .chartClr1:
            instanceColor = UIColor(red: 0.00, green: 0.74, blue: 0.83, alpha: 1.00)
        case .chartClr2:
            instanceColor = UIColor(red: 0.68, green: 0.51, blue: 0.98, alpha: 1.00)
        case .chartClr3:
            instanceColor = UIColor(red: 0.97, green: 0.85, blue: 0.51, alpha: 1.00)
        case .chartClr4:
            instanceColor =  UIColor(red: 0.97, green: 0.48, blue: 0.45, alpha: 1.00)
        case .chartClr5:
            instanceColor = UIColor(red: 0.40, green: 0.97, blue: 0.42, alpha: 1.00)
        case .chartClr6:
            instanceColor = UIColor(red: 0.24, green: 0.73, blue: 0.63, alpha: 0.40)
        case .chartClr7:
            instanceColor = UIColor(red: 0.62, green: 0.34, blue: 0.75, alpha: 0.70)
        case .chartClr8:
            instanceColor =  UIColor(red: 0.42, green: 0.49, blue: 0.76, alpha: 0.70)
        case .chartClr9:
            instanceColor = UIColor(red: 0.42, green: 0.76, blue: 0.59, alpha: 0.70)
        case .chartClr10:
            instanceColor = UIColor(red: 0.26, green: 0.38, blue: 0.50, alpha: 0.70)
        case .chartClr11:
            instanceColor = UIColor(red: 0.64, green: 0.36, blue: 0.40, alpha: 0.70)
        case .chartClr12:
            instanceColor = UIColor(red: 0.71, green: 0.64, blue: 0.45, alpha: 0.90)
        case .chartClr13:
            instanceColor =  UIColor(red: 0.39, green: 0.52, blue: 0.43, alpha: 0.70)
        case .chartClr14:
            instanceColor = UIColor(red: 0.70, green: 0.15, blue: 0.94, alpha: 0.50)
        case .chartClr15:
            instanceColor = UIColor(red: 0.42, green: 0.80, blue: 0.97, alpha: 0.70)
        case .colorPrimary:
            instanceColor = UIColor(red: 0.28, green: 0.18, blue: 0.37, alpha: 1.00)
        case .colorPrimaryDark:
            instanceColor = UIColor(red: 0.25, green: 0.13, blue: 0.36, alpha: 1.00)
        case .colorGreen:
            instanceColor = UIColor(red: 0.44, green: 0.67, blue: 0.24, alpha: 1.00)
        case .colorPrice:
              instanceColor =   UIColor(red: 0.97, green: 0.68, blue: 0.25, alpha: 1.00)
        case .backgroundred:
            instanceColor = UIColor(red: 0.98, green: 0.96, blue: 1.00, alpha: 1.00)
        case .borderColor:
            
            instanceColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
       
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
    
    var cgColor: CGColor {
        return self.value.cgColor
    }
}
  
