//
//  SearchViewController.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit

class SearchViewController: UIViewController, CoordinatorDelegate {
    private let viewInstance = SearchView()
    private let dataSource: ImageDataSource = PixabayDataSource()
    private var images: [Image] = []
    private var selectedImages: [Image] = []
    
    weak var coordinator: Coordinator?
    
    override func loadView() {
        view = viewInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInstance.delegate = self
    }
}

extension SearchViewController: SearchViewDelegate {
    func onToggleSelected(_ selectedImage: Image, selected: Bool) {
        let selectedImagesIndex = selectedImages.firstIndex(where: { image in image.id == selectedImage.id} )
        
        if selectedImagesIndex == nil {
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
            cell.set(image: image, selected: selected)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count + images.count
    }
    
    func onSearchEditingEnd(_ query: String) {
        self.images = []
        self.viewInstance.reloadCollectionData()
        
        dataSource.fetchImages(query) { (data, error) in
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
}
