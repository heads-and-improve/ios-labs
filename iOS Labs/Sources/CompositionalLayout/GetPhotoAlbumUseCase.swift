//
//  GetItalianPhotosUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 26.10.2021.
//

import UIKit
import Combine

struct GetPhotoAlbumUseCase {
    
    private let getPhotos = GetPhotosUseCase()
    
    private var cancellables = Set<AnyCancellable>()
    
    func callAsFunction() -> AnyPublisher<PhotoAlbum, Never> {
        getPhotos("firenze")
            .map { (result: Result<[UIImage], Error>) -> [UIImage] in
                switch result {
                case .success(let photos):
                    return photos
                case .failure:
                    return []
                }
            }
            .replaceError(with: [])
            .zip(
                getPhotos("ferrari")
                    .map { (result: Result<[UIImage], Error>) -> [UIImage] in
                        switch result {
                        case .success(let photos):
                            return photos
                        case .failure:
                            return []
                        }
                    }
                    .replaceError(with: []),
                getPhotos("pizza")
                    .map { (result: Result<[UIImage], Error>) -> [UIImage] in
                        switch result {
                        case .success(let photos):
                            return photos
                        case .failure:
                            return []
                        }
                    }
                    .replaceError(with: [])
            )
            .map { PhotoAlbum($0.0, $0.1, $0.2) }
            .eraseToAnyPublisher()
    }
}
