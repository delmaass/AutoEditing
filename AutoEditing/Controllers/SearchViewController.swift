//
//  SearchViewController.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit

class SearchViewController: UIViewController {
    private let viewInstance = SearchView()
    private let dataSource: ImageDataSource = PixabayDataSource()
    
    override func loadView() {
        view = viewInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInstance.delegate = self
    }
}

extension SearchViewController: SearchViewDelegate {
    func onSearchEditingEnd(_ query: String) {
        dataSource.fetchImages(query)
    }
}
