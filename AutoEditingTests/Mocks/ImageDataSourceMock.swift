//
//  ImageDataSourceMock.swift
//  AutoEditing
//
//  Created by Louis Delmas on 21/02/2025.
//

@testable import AutoEditing

class ImageDataSourceMock: ImageDataSource {
    var mockImages: [Image] = []
    
    func fetchImages(_ query: String, limit: Int, offset: Int, completion: @escaping ([Image]?, Error?) -> Void) {
        completion(mockImages, nil)
    }
}

