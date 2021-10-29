//
//  GetItalianPhotosUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 26.10.2021.
//

import UIKit
import Combine

final class CompositionalLayoutNetworkingClient {
    
    private let getPhotos = GetPhotosUseCase()
    
    private var cancellables = Set<AnyCancellable>()
    
    func callAsFunction(
        tagOne: String,
        _ tagTwo: String,
        _ tagThree: String,
        onStart: @escaping () -> Void,
        onComplete: @escaping (PhotoAlbum) -> Void) {
        
        onStart()
        getPhotos(tagOne)
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
                getPhotos(tagTwo)
                    .map { (result: Result<[UIImage], Error>) -> [UIImage] in
                        switch result {
                        case .success(let photos):
                            return photos
                        case .failure:
                            return []
                        }
                    }
                    .replaceError(with: []),
                getPhotos(tagThree)
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
            .receive(on: RunLoop.main)
            .sink { onComplete($0) }
            .store(in: &cancellables)
    }
}
