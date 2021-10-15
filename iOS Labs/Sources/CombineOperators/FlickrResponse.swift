//
//  FlickrResponse.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 09.09.2021.
//

import Foundation

struct FlickrResponse: Decodable {
    
    let photos: Photos

    struct Photos: Decodable {
        
        let photo: [Photo]

        struct Photo: Decodable {
            let id: String
            let secret: String
            let server: String
        }

    }

}
