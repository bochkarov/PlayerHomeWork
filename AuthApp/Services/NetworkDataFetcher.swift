//
//  NetworkDataFetcher.swift
//  AuthApp
//
//  Created by Алексей Пархоменко on 06.05.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation


class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchTracks(urlString: String, completion: @escaping (SearchResponse?) -> Void) {
        networkService.request(urlString: urlString) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data!)
                    completion(tracks)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(nil)
                }
            }
        }
    }
}
