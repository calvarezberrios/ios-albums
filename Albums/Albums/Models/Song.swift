//
//  Song.swift
//  Albums
//
//  Created by Carlos E. Alvarez-Berrios on 4/18/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

struct Song: Decodable {
    let id: String
    let title: String
    let duration: String
    
    enum SongCodingKeys: String, CodingKey {
        case id
        case name
        case duration
    }
    
    enum NameCodingKeys: String, CodingKey {
        case title
    }
    
    enum DurationCodingKeys: String, CodingKey {
        case duration
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: SongCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        self.title = try nameContainer.decode(String.self, forKey: .title)
        
        
        let durationContainer = try container.nestedContainer(keyedBy: DurationCodingKeys.self, forKey: .duration)
        self.duration = try durationContainer.decode(String.self, forKey: .duration)
    }
}
