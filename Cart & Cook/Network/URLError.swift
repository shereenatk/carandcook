//
//  URLError.swift
//  Fixperts
//
//  Created by Apple on 2/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
fileprivate extension String {
    static let invalidURL = "URL is not valid"
}
enum URLError: Error {
    
    case urlMalformatted
    var value: String {
        switch self {
        case .urlMalformatted:
            return .invalidURL
        }
    }
}
