//
//  ThreeClosuresEnvironment.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.10.2021.
//

import Foundation
import Combine

struct ThreeClosuresNetworkingEnvironment {

    enum Target {
        case dev
        case qa
        case prod
    }

    let getTemp: ThreeClosuresGetTempUseCase

    private init(getTemp: ThreeClosuresGetTempUseCase) {
        self.getTemp = getTemp
    }

    static func current(_ env: Target) -> ThreeClosuresNetworkingEnvironment {
        switch env {
        case .dev:
            return ThreeClosuresNetworkingEnvironment(getTemp: .init())
        case .qa:
            return ThreeClosuresNetworkingEnvironment(getTemp: .init())
//            return ThreeClosuresNetworkingEnvironment(getTemp: .trulyHot)
        case .prod:
            return ThreeClosuresNetworkingEnvironment(getTemp: .init())
        }
    }
    
}
