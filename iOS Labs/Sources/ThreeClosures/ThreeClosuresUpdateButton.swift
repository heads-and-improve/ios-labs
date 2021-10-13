//
//  ThreeClosuresRefreshButton.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.10.2021.
//

import UIKit
import Combine

final class ThreeClosuresUpdateButton: UIButton {

    var city: String?    
}

//final class ThreeClosuresUpdateButton: UIButton {
//
//    var city: String?
//
//    var onTap: ((String?) -> Void)?
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        addTarget(self, action: #selector(handleTapped), for: .touchDown)
//    }
//
//    @objc
//    private func handleTapped() {
//        onTap?(city)
//    }
//
//}
