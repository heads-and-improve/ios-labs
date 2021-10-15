//
//  CombineErrorsEnvironment.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 22.09.2021.
//

import Foundation
import UIKit

final class CombineErrorsEnvironment {
    
    let apiKey: String?
    
    private init() {
        self.apiKey = Bundle.main.url(forResource: "apikeys", withExtension: "plist")
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil) }
            .flatMap { $0 as? Dictionary<String, String> }
            .flatMap { $0["flickr"] }
    }
    
    static let shared = CombineErrorsEnvironment()
    
}
