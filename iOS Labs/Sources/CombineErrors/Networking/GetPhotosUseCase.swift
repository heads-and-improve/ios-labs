//
//  GetPhotosUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import UIKit
import Combine

struct GetPhotosUseCase {

    typealias Result = Swift.Result<[UIImage], Error>

    private let getPhotosIds = GetPhotosIdsUseCase()
    private let getPhoto = GetPhotoUseCase()

    func callAsFunction(_ tag: String) -> AnyPublisher<Result, Error> {
        getPhotosIds(tag)
            .flatMap { photos in
                photos.publisher
                    .flatMap { self.getPhoto($0) }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .map { photos -> Result in .success(photos) }
            .eraseToAnyPublisher()
    }
    
}
