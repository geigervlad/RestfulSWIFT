//
//  RestfulRead.swift
//  PromisedRestfulSwift
//
//  Created by Vlad Geiger on 15.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol RestfulRead: HTTPTools { }

public extension RestfulRead {
    
    /// Executes a GET request on a specific resource: solutions/{ID}
    /// - Parameter url: the url with the resource identification
    /// - Returns: A promise which resolves if the request was successful and contains the expected entity
    func read<U: Decodable>(_ url: URL) -> Promise<U> {
        let request = URLRequest(url: url)
        return interceptor.intercept(request)
            .then(execute)
            .map(toValidatedEntity)
    }
    
}
