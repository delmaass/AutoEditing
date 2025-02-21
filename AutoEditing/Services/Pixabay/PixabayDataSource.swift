//
//  PixabayDataSource.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import Foundation

class PixabayDataSource: ImageDataSource {
    func fetchImages(_ query: String, completion: @escaping ([Image]?, Error?) -> (Void)) {
        guard let apiKey = ProcessInfo.processInfo.environment["PIXABAY_API_KEY"] else {
            fatalError("PIXABAY_API_KEY environment variable needs to be set")
        }
        
        var url = URL(string: "https://pixabay.com/api/?image_type=photo&key=\(apiKey)")!
        url.appendQueryItem(name: "q", value: query)
        
        Networker.shared.get(url) { (data: Data?, error: Error?) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PixabayResponseDto.self, from: data)
                
                DispatchQueue.main.async {
                    completion(response.hits.map { Image(id: $0.id.description, url: $0.webformatURL )}, nil)
                }
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
}
