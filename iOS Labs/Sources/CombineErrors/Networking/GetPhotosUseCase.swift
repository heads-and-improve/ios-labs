//
//  GetPhotosUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import UIKit
import Combine

struct GetPhotosUseCase {

    typealias Result = Swift.Result<[UIImage], NetworkableError>

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
//            .tryCatch { error -> AnyPublisher<Result, Error> in
//                guard let nwError = error as? NetworkableError else { throw error }
//                return Just<Result>(.failure(nwError))
//                    .setFailureType(to: Error.self)
//                    .eraseToAnyPublisher()
//            }
//            .catch { error -> AnyPublisher<Result, Error> in
//                return Just<Result>(.failure(error as! NetworkableError))
//                    .setFailureType(to: Error.self)
//                    .eraseToAnyPublisher()
//            }
//            .replaceError(with: .success([]))
//            .retry(2)
            .eraseToAnyPublisher()
    }
    
}
