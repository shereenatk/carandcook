//
//  ResponseError.swift
//  Fixperts
//
//  Created by Apple on 2/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
open class ResponseError: Error {
    public enum ErrorType: String {
        case error, warning, info
    }
    open var errorCode: String = ""
    open var localizedDescription: String = ""
    open var errorType: ErrorType = .error
    open var request: URLRequest?
    open var JSON: Any?
    open var statusCode: Int = 0
    public init(error: String, localizedDescription: String = "", errorType: ErrorType = .error, statusCode: Int = 0) {
        self.errorCode = error
        self.localizedDescription = localizedDescription.isEmpty ? NSLocalizedString(errorCode, comment: "") : localizedDescription
        self.errorType = errorType
        self.statusCode = statusCode
    }
    open var description: String {
        return String(format: "Error: %@ Description: %@", errorCode, localizedDescription)
    }
}

