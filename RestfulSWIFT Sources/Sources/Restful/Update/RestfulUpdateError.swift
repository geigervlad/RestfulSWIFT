//
//  RestfulUpdateError.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 21.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

// MARK: Definition

public protocol RestfulUpdateError: HTTPToolsValidation {
    
    /// Executes a PUT request on a resource: /solutions with the entity data
    /// - Parameter url: the url of the resource to update
    /// - Returns: a promise which resolves if the update was successful
    func update<T: Encodable>(url: URL, entity: T) -> Promise<Void>
    
    /// Executes a PUT request on a resource: /solutions with the entity data and returns the server response
    /// - Parameter url: the url of the resource to update
    /// - Returns: a promise which resolves if the update was successfull and contains  the server response data
    func update<T: Encodable, U: Decodable>(url: URL, entity: T) -> Promise<U>
}

// MARK: Default Implementation

public extension RestfulUpdateError {
        
    func update<T: Encodable>(url: URL, entity: T) -> Promise<Void> {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.put.rawValue
        return interceptor.intercept(request)
            .then(execute)
            .map(toValidatedError)
    }
    
    func update<T: Encodable, U: Decodable>(url: URL, entity: T) -> Promise<U> {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.put.rawValue
        return interceptor.intercept(request)
            .then(execute)
            .map(toValidatedEntityWithError)
    }
    
}
