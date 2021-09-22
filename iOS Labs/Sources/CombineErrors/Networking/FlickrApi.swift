//
//  FlickrApi.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 22.09.2021.
//

import Foundation

enum FlickrApi {
    
    case getPhotosByTag(String)
    case getPhoto(String, String, String)
    
}

extension FlickrApi: RequestComposable {
    
    var scheme: String? {
        "https"
    }
    
    var host: String? {
        switch self {
        case .getPhotosByTag:
            return "flickr.com"
        case .getPhoto:
            return "live.staticflickr.com"
        }
    }
    
    var path: String {
        switch self {
        case .getPhotosByTag:
            return "/services/rest/"
        case .getPhoto(let server, let id, let secret):
            return "/\(server)/\(id)_\(secret)_c.jpg"
        }
    }
    
    var method: RequestMethod {
        .get
    }
    
    var query: [String : String?] {
        switch self {
        case .getPhotosByTag(let tag):
            return [
                "method": "flickr.photos.search",
                "api_key": nil,
                "tags": tag,
                "per_page": "25",
                "page": "1",
                "format": "json",
                "nojsoncallback": "1"
            ]
        case .getPhoto:
            return [:]
        }
    }
    
    
}
