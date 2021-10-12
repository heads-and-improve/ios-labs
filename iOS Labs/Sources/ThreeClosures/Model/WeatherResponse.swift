//
//  WeatherResponse.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 12.10.2021.
//

import Foundation

struct WeatherResponse: Decodable {
    
    let main: Main
    
    struct Main: Decodable {

        let temp: Double
    }
}
