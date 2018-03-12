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
    
    static let networkTimeoutError = CustomError(title: "Network Timeout Error", description:"Network timeout", code: 1001)
    
    static let networkRequestFailure = CustomError(title: "Network Request Failure", description: "Network request failure. Verify in the settings if the server is correct.", code: 1002)
    
    static let requestCreationError = CustomError(title: "Problem creating request", description: "Problem creating request", code: 1003)
    
    
    static let accessTokenNotProvidedError = CustomError(title: "Access Forbidden", description: "Server access not available.", code: 1004)
    
    static let httpError404 = CustomError(title: "HTTP Error", description: "(404) Not found", code: 1005)
    
    static let httpError403 = CustomError(title: "HTTP Error", description: "(403) Forbidden", code: 1006)
    
    static let jsonUnwrappingError = CustomError(title: "JSON Error", description: "Problem unwrapping JSON", code: 1007)
    static let tokenNotValidError = CustomError(title: "Authentication Error", description: "The access token is not valid", code: 1008)
    
    static let serverSettingsNotSavedError = CustomError(title: "Settings Error", description: "Server settings could not be saved", code: 1009)
    
   static let userSettingsNotSavedError = CustomError(title: "Settings Error", description: "Default user settings could not be saved", code: 1010)
}
