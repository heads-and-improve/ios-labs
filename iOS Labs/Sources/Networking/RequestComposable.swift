//
//  RequestComposable.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 21.09.2021.
//

import Foundation

enum RequestMethod: String {

    case get = "GET"
    case post = "POST"
    case set = "SET"
    case put = "PUT"
    case delete = "DELETE"
}

protocol RequestComposable {
    
    var scheme: String { get }

    var host: String { get }
    
    var path: String { get }
    
    var query: [String: String?]? { get }
    
    var method: RequestMethod { get }
    
    var data: Data? { get }
    
}

extension RequestComposable {
    
    var scheme: String { "https" }
    
    var query: [String: String]? { nil }
    
    var data: Data? { nil }
    
}

