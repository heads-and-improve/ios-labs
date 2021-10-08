//
//  GetPhotoUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import UIKit
import Combine

struct GetPhotoUseCase {
    
    private let api = RequestProvider<FlickrApi>()
    
    init() { }
    
    func callAsFunction(_ photo: FlickrResponse.Photos.Photo) -> AnyPublisher<UIImage, Error> {
        api.task(.getPhoto(photo.server, photo.id, photo.secret))
    }
    
}
