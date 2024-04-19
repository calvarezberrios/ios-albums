//
//  Song.swift
//  Albums
//
//  Created by Carlos E. Alvarez-Berrios on 4/18/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

struct Song: Codable {
    let id: String
    var title: String
    var duration: String
    
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
    
    init(title: String, duration: String) {
        self.id = UUID().uuidString
        self.title = title
        self.duration = duration
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: SongCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        self.title = try nameContainer.decode(String.self, forKey: .title)
        
        
        let durationContainer = try container.nestedContainer(keyedBy: DurationCodingKeys.self, forKey: .duration)
        self.duration = try durationContainer.decode(String.self, forKey: .duration)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: SongCodingKeys.self)
        try container.encode(self.id, forKey: .id)
        
        var nameContainer = container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        try nameContainer.encode(self.title, forKey: .title)
        
        var durationContainer = container.nestedContainer(keyedBy: DurationCodingKeys.self, forKey: .duration)
        try durationContainer.encode(self.duration, forKey: .duration)
    }
}
