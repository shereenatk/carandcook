//
//  NetworkConstants.swift
//  DineSouq V2
//
//  Created by MAC on 3/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
enum NetworkConstants: Int {
    case code = 200
    case failure = 400
    
    var value: Int {
        return self.rawValue
    }
}

enum NetworkResponseStatus: String {
    case success = "true"
    case registerSuccess = "Congratulations! your account is created Successfully."
    
    var value: String {
        return self.rawValue
    }
}
