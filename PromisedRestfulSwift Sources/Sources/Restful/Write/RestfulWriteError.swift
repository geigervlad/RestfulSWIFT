//
//  RestfulWriteError.swift
//  PromisedRestfulSwift
//
//  Created by Vlad Geiger on 21.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol RestfulWriteError: HTTPToolsValidation { }

public extension RestfulWriteError {
    
    /// Executes a POST request on a resource with no body: url encoding
    /// - Parameter url: the url with the query parameters
    /// - Returns: A promise which resolves if the request was successful and contains the server response
    func write<U: Decodable>(_ url: URL) -> Promise<U> {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post.rawValue
        return interceptor.intercept(request)
            .then(execute)
            .map(toValidatedEntityWithError)
    }
    
    /// Executes a POST request on a resource with no body: url encoding
    /// - Parameter url: the url with the query parameters
    /// - Returns: A promise which resolves if the request was successful and contains the value of the HTTP Location Header
    func writeAndExtractLocation(_ url: URL) -> Promise<String> {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post.rawValue
        return interceptor.intercept(request)
            .then(execute)
            .map(toValidatedLocationWithError)
    }
    
    /// Executes a POST request on a resource: /solutions with the entity data and returns the server response
    /// - Parameter url: the url for the resource to create
    /// - Parameter entity: the entity to create
    /// - Returns: A promise which resolves if the request was successful and contains the server response
    func write<T: Encodable, U: Decodable>(_ url: URL, _ entity: T) -> Promise<U> {
        return buildPostRequest(url, entity)
            .then(interceptor.intercept)
            .then(execute)
            .map(toValidatedEntityWithError)
    }
    
    /// Executes a POST request on a resource: /solutions with the entity data and returns the Location Header Value
    /// - Parameter url: the url for the resource to create
    /// - Parameter entity: the entity to create
    /// - Returns: A promise which resolves if the request was successful and contains the value of the HTTP Location Header
    func writeAndExtractLocation<T: Encodable>(_ url: URL, _ entity: T) -> Promise<String> {
        return buildPostRequest(url, entity)
            .then(interceptor.intercept)
            .then(execute)
            .map(toValidatedLocationWithError)
    }
    
    /// Executes a POST request on a resource: /solutions with the entity data and extracts the header values, if none found empty string is returned
    /// - Parameter url: the url for the resource to create
    /// - Parameter entity: the entity to create
    /// - Parameter headerKeys: the keys of the headers for which to extract
    /// - Returns: A promise which resolves if the request was successful and contains the requested http response headers
    func writeAndExtractHeaders<T: Encodable>(_ url: URL, _ entity: T, _ headerKeys: [String]) -> Promise<HTTPHeadersType> {
        return buildPostRequest(url, entity)
            .then(interceptor.intercept)
            .then(execute)
            .map { try self.toValidatedHeadersWithError($0, headerKeys) }
    }
}
