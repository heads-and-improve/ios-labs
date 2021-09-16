//
//  GetPhotoUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import UIKit
import Combine

struct GetPhotoUseCase: Networkable {

    private let factory: RequestFactory<(server: String, id: String, secret: String)>

    init() {
        self.factory = .init("https://live.staticflickr.com/") { _, value in
            "\(value.server)/\(value.id)_\(value.secret)_c.jpg"
        }
    }

    func callAsFunction(_ photo: FlickrResponse.Photos.Photo) -> AnyPublisher<UIImage, Error> {
        if let request = factory((photo.server, photo.id, photo.secret)) {
            return self.load(request)
        } else {
            return Fail<UIImage, URLError>(error: URLError(.badURL, userInfo: [:]))
                .mapError { NetworkableError.url($0) }
                .eraseToAnyPublisher()
        }
    }
    
}
