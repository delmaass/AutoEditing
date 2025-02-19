//
//  PixabayDataSource.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import Foundation

enum NetworkError: Error {
    case badResponse
    case badStatusCode(Int)
    case badData
}

class PixabayDataSource: ImageDataSource {
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func fetchImages(_ query: String, completion: @escaping ([Image]?, Error?) -> (Void)) {
        guard let apiKey = ProcessInfo.processInfo.environment["PIXABAY_API_KEY"] else {
            fatalError("PIXABAY_API_KEY environment variable needs to be set")
        }
        
        let q = query.replacingOccurrences(of: " ", with: "+")
        
        let url = URL(string: "https://pixabay.com/api/?image_type=photo&q=\(q)&key=\(apiKey)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("not the right response")
                DispatchQueue.main.async {
                    completion(nil, NetworkError.badResponse)
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("not an ok status code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(nil, NetworkError.badStatusCode(httpResponse.statusCode))
                }
                return
            }
            
            guard let data = data else {
                print("bad data")
                DispatchQueue.main.async {
                    completion(nil, NetworkError.badData)
                }
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
        
        task.resume()
    }
}
