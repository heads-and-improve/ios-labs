//
//  GetPhotosUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import UIKit
import Combine

struct GetPhotosUseCase {
    
    private let getPhotosIds = GetPhotosIdsUseCase()
    private let getPhoto = GetPhotoUseCase()

    func callAsFunction(_ tag: String) -> AnyPublisher<[UIImage], Error> {
        getPhotosIds(tag)
            .flatMap { photos in
                photos.publisher
                    .flatMap { photo -> AnyPublisher<UIImage?, Never> in
                        self.getPhoto(photo)
                            .replaceError(with: nil)
                            .eraseToAnyPublisher()
                    }
                    .compactMap { $0 }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
}
