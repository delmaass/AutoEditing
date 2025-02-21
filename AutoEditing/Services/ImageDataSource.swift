//
//  ImageDataSource.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

protocol ImageDataSource {
    func fetchImages(_ query: String, limit: Int, offset: Int, completion: @escaping ([Image]?, Error?) -> (Void))
}
