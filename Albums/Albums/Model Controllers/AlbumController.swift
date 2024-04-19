//
//  AlbumController.swift
//  Albums
//
//  Created by Carlos E. Alvarez-Berrios on 4/18/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

class AlbumController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case noData
        case server(Error)
        case unexpectedStatusCode
        case badDecode
        case badEncode
    }
    
    var albums = [Album]()
    
    private let baseURL = URL(string: "https://music-albums-api-default-rtdb.firebaseio.com")!
    private(set) lazy var  albumsURL = URL(string: "/albums.json", relativeTo: baseURL)!
    
    private var task: URLSessionTask?
    
    func getAlbums(completion: @escaping (NetworkError?) -> Void) {
        task?.cancel()
        
        let requestURL = albumsURL
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error fetching albums: \(error)")
                completion(.server(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.unexpectedStatusCode)
                return
            }
            
            guard let data = data else {
                completion(.noData)
                return
            }
            
            do {
                let albums = try JSONDecoder().decode([String: Album].self, from: data)
                self.albums = albums.values.map({ $0 })
                completion(nil)
            } catch {
                NSLog("Error decoding albums data: \(error)")
                completion(.badDecode)
            }
        }
        
        task?.resume()
    }
    
    func put(album: Album) {
        task?.cancel()
        
        let requestURL = URL(string: "/albums/\(album.id).json", relativeTo: baseURL)!
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let albumJSON = try JSONEncoder().encode(album)
            request.httpBody = albumJSON
        } catch {
            NSLog("Error encoding album data: \(error)")
            return
        }
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error Putting album to database: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("\(NetworkError.unexpectedStatusCode.localizedDescription), code: \(response.statusCode)")
                return
            }
            
            guard let data = data else {
                NSLog("No Data received from api: \(NetworkError.noData.localizedDescription)")
                return
            }
            
            do {
                let _ = try JSONDecoder().decode(Album.self, from: data)
                
            } catch {
                NSLog("Error decoding album data: \(error)")
            }
        }
        
        task?.resume()
        
    }
    
    func createAlbum(name: String, artist: String,  genres: [String], coverArt: [String], songs: [Song]?) {
        let newAlbum = Album(name: name, artist: artist, genres: genres, coverArt: coverArt, songs: songs ?? [])
        self.albums.append(newAlbum)
        put(album: newAlbum)
    }
    
    func createSong(title: String, duration: String) -> Song {
        return Song(title: title, duration: duration)
    }
    
    func update(album: Album, name: String, artist: String, genres: [String], coverArt: [String], songs: [Song]) {
        
        if !self.albums.contains(where: { $0.id == album.id }) {
            NSLog("Album with id: \(album.id) does not exist.")
            return
        }
        
        var updated = album
        updated.name = name
        updated.artist = artist
        updated.genres = genres
        updated.coverArt = coverArt.compactMap { URL(string: $0) }
        updated.songs = songs
        
        self.albums = self.albums.map { currentAlbum -> Album in
            if currentAlbum.id == updated.id {
                return updated
            }
            return currentAlbum
        }
        
        put(album: updated)
    }
    
    // MARK: - testCodableExampleAlbum: tests to make sure there are no errors when encoding or decoding the album and song data
    
    func testCodableExampleAlbum() {
        guard let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
            NSLog("Error getting getting example album file")
            return
        }
        do {
            let data = try Data(contentsOf: urlPath)
            
            let album = try JSONDecoder().decode(Album.self, from: data)
            
            let _ = try JSONEncoder().encode(album)
            
        } catch {
            NSLog("Error getting data and/or decoding/encoding from example album: \(error)")
        }
    }
}
