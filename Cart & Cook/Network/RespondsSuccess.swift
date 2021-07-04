//
//  RespondsSuccess.swift
//  Fixperts
//
//  Created by Apple on 2/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
open class ResponseSuccess: NSObject {
    open var URLRequest: URLRequest?
    open var URLResponse: URLResponse?
    open var data: Data?
    open var JSON: Any?
    open var error: ResponseError?
    open var statusCode: Int = 0
    open var success: Bool {
        return error == nil && (statusCode == 200 || statusCode == 201)
    }
    public init(URLRequest: URLRequest?, response: URLResponse?) {
        super.init()
        self.URLRequest = URLRequest
        self.URLResponse = response
    }
}
