//
//  CustomError.swift
//  LSFManager
//
//  Created by Daniel Montano on 20.12.17.
//  Copyright © 2017 danielmontano. All rights reserved.
//

import Foundation

import Foundation

/// Use this struct to create custom error instances of the
/// current project. In this case for the LSFManager
struct CustomError: LocalizedError {
    
    var title: String?
    var code: Int
    var errorDescription: String { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
    
    func append(str: String) -> CustomError {
        return CustomError(title: self.title, description: "\(self._description): \(str)", code: self.code)
    }
}

class CustomErrors {
    
    static let networkTimeoutError = CustomError(title: "Network Timeout Error", description:"Network timeout", code: 100)
    
    static let networkRequestFailure = CustomError(title: "Network Request Failure", description: "Network request failure", code: 101)
    
    static let requestCreationError = CustomError(title: "Problem creating request", description: "Problem creating request", code: 154)
    
    static let jsonUnwrappingError = CustomError(title: "JSON Error", description: "Problem unwrapping JSON", code: 9)
    
    static let accessTokenNotProvidedError = CustomError(title: "Access Forbidden", description: "Server access not available.", code: 203)
    
    static let httpError404 = CustomError(title: "HTTP Error", description: "(404) Not found", code: 203)
    
    static let httpError403 = CustomError(title: "HTTP Error", description: "(403) Forbidden", code: 203)
    
    static let tokenNotValidError = CustomError(title: "Authentication Error", description: "The access token is not valid", code: 213)
}
