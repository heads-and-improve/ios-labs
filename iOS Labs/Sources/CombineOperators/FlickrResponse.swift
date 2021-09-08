//
//  FlickrResponse.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 09.09.2021.
//

import Foundation

struct FlickrResponse: Decodable {
    
    struct Photos: Decodable {
        
        struct Photo: Decodable {
            let id: String
            let secret: String
            let server: String
        }

        let photo: [Photo]
    }

    let photos: Photos
}
