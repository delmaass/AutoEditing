//
//  SearchViewController.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit

let NUMBER_ITEMS_PER_PAGE = 20

class SearchViewController: UIViewController, CoordinatorDelegate {
    private let viewInstance = SearchView()
    private let dataSource: ImageDataSource
    
    var images: [Image] = []
    var selectedImages: [Image] = []
    weak var coordinator: Coordinator?
    
    init(dataSource: ImageDataSource? = nil) {
        self.dataSource = dataSource ?? PixabayDataSource()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.dataSource = PixabayDataSource()
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = viewInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInstance.delegate = self
    }
}

extension SearchViewController: SearchViewDelegate {
    func onToggleSelected(_ id: String, selected: Bool) {
        let selectedImagesIndex = selectedImages.firstIndex(where: { image in image.id == id} )
        
        if selectedImagesIndex == nil {
            let selectedImage = images.first(where: { image in image.id == id })
            
            guard let selectedImage = selectedImage else {
                return
            }
            
            selectedImages.append(selectedImage)
        } else {
            selectedImages.remove(at: selectedImagesIndex!)
        }
        
        viewInstance.updateButton(count: selectedImages.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultsCollectionCell", for: indexPath) as! SearchResultsCollectionCell
        
        var image: Image? = nil
        var selected = false
        
        if indexPath.row < selectedImages.count {
            image = selectedImages[indexPath.row]
            selected = true
        } else if indexPath.row - selectedImages.count < images.count {
            image = images[indexPath.row - selectedImages.count]
        }
        
        if let image = image {
            Networker.shared.download(URL(string: image.url)!) { (data, error) in
                guard let data = data else {
                    return
                }
                
                DispatchQueue.main.async {
                    cell.configure(id: image.id, image: UIImage(data: data)!, selected: selected)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count + images.count
    }
    
    func onSearchEditingEnd(_ query: String) {
        self.images = []
        self.viewInstance.reloadCollectionData()
        
        dataSource.fetchImages(query, limit: NUMBER_ITEMS_PER_PAGE, offset: 0) { (data, error) in
            guard let images = data else {
                return
            }
            
            self.images = images
            self.viewInstance.reloadCollectionData()
        }
    }
    
    func onContinue() {
        coordinator?.navigateToCarousel(images: selectedImages)
    }
    
    func collectionView(willDisplayItemAt indexPath: IndexPath, query: String) {
        guard images.count > 0 && indexPath.row == images.count - 1 else {
            return
        }
        
        dataSource.fetchImages(query, limit: NUMBER_ITEMS_PER_PAGE, offset: images.count) { (data, error) in
            guard let images = data else {
                return
            }
            
            self.images.append(contentsOf: images)
            self.viewInstance.reloadCollectionData()
        }
    }
}
