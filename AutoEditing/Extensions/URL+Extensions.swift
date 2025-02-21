//
//  URL+Extensions.swift
//  AutoEditing
//
//  Created by Louis Delmas on 21/02/2025.
//

import Foundation

extension URL {
    mutating func appendQueryItem(name: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return
        }

        var cs = CharacterSet.urlQueryAllowed
        cs.remove("+")
        cs.remove("?")
        cs.remove("=")
        cs.remove("&")
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)

        urlComponents.percentEncodedQuery = queryItems.map { queryItem in
            queryItem.name.addingPercentEncoding(withAllowedCharacters: cs)!
            + "=" + (queryItem.value?.addingPercentEncoding(withAllowedCharacters: cs) ?? "")
        }.joined(separator: "&")

        self = urlComponents.url!
    }
}
