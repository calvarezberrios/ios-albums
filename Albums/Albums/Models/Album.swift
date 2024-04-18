//
//  Album.swift
//  Albums
//
//  Created by Carlos E. Alvarez-Berrios on 4/18/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

struct Album: Codable {
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
        self.songs = try container.decode([Song].self, forKey: .songs)
        
        var coverArtURLs = [URL]()
        var coverArtContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        
        while !coverArtContainer.isAtEnd {
            let urlContainer = try coverArtContainer.nestedContainer(keyedBy: CoverArtCodingKeys.self)
            if let url = URL(string: try urlContainer.decode(String.self, forKey: .url)) {
                coverArtURLs.append(url)
            }
        }
        self.coverArt = coverArtURLs
        
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: AlbumCodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.artist, forKey: .artist)
        try container.encode(self.genres, forKey: .genres)
        try container.encode(self.songs, forKey: .songs)
        
        var coverArtContainer = container.nestedUnkeyedContainer(forKey: .coverArt)
        for art in self.coverArt {
            var urlContainer = coverArtContainer.nestedContainer(keyedBy: CoverArtCodingKeys.self)
            try urlContainer.encode(art.absoluteString, forKey: .url)
        }
        
        
    }
    
}


