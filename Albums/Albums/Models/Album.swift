//
//  Album.swift
//  Albums
//
//  Created by Carlos E. Alvarez-Berrios on 4/18/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

struct Album: Decodable {
    let id: String
    let name: String
    let artist: String
    let genres: [String]
    let coverArt: [URL]
    let songs: [Song]
    
    enum AlbumCodingKeys: String, CodingKey {
        case id
        case name
        case artist
        case coverArt
        case genres
        case songs
    }
    
    enum CoverArtCodingKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.genres = try container.decode([String].self, forKey: .genres)
        
        var coverArtURLs = [URL]()
        var coverArtContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        
        while !coverArtContainer.isAtEnd {
            let urlContainer = try coverArtContainer.nestedContainer(keyedBy: CoverArtCodingKeys.self)
            if let url = URL(string: try urlContainer.decode(String.self, forKey: .url)) {
                coverArtURLs.append(url)
            }
        }
        self.coverArt = coverArtURLs
        
        var songs = [Song]()
        var songContainer = try container.nestedUnkeyedContainer(forKey: .songs)
        while !songContainer.isAtEnd {
            songs.append(try songContainer.decode(Song.self))
        }
        self.songs = songs
        
    }
    
}


