//
//  AlbumController.swift
//  Albums
//
//  Created by Carlos E. Alvarez-Berrios on 4/18/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

class AlbumController {
    func testDecodingExampleAlbum() {
        guard let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
            NSLog("Error getting getting example album file")
            return
        }
        do {
            let data = try Data(contentsOf: urlPath)
            
            let album = try JSONDecoder().decode(Album.self, from: data)
            
        } catch {
            NSLog("Error getting data and/or decoding from example album: \(error)")
        }
    }
}
