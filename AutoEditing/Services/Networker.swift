//
//  Networker.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import Foundation

enum NetworkError: Error {
    case badResponse
    case badStatusCode(Int)
    case badData
    case badLocalUrl
}

class Networker {
    static let shared = Networker()
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func get(_ url: URL, completion: @escaping (Data?, Error?) -> (Void)) {
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
            
            completion(data, nil)
        }
        
        task.resume()
    }
    
    func download(_ url: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.downloadTask(with: request) { localUrl, response, error in
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
            
            guard let localUrl = localUrl else {
                print("bad local url")
                DispatchQueue.main.async {
                    completion(nil, NetworkError.badLocalUrl)
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
