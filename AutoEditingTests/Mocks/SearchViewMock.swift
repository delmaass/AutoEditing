//
//  SearchViewMock.swift
//  AutoEditing
//
//  Created by Louis Delmas on 21/02/2025.
//

@testable import AutoEditing

class SearchViewMock: SearchView {
    var reloadCollectionDataCallCount = 0
    
    override func reloadCollectionData() {
        reloadCollectionDataCallCount += 1
    }
}
