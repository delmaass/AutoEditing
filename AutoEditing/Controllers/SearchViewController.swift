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
    private var images: [Image]?
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
    func onToggleSelected(_ cellIndexPath: IndexPath, selected: Bool) {
        guard let images = images else {
            return
        }
        
        let selectedImage = images[cellIndexPath.row]
        
        let selectedImagesIndex = selectedImages.firstIndex(where: { image in image.id == selectedImage.id} )
        
        if selectedImagesIndex == nil {
            selectedImages.append(selectedImage)
            print("Adding \(selectedImage.id)")
        } else {
            selectedImages.remove(at: selectedImagesIndex!)
            print("Removing \(selectedImage.id)")
        }
        
        viewInstance.updateButton(count: selectedImages.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultsCollectionCell", for: indexPath) as! SearchResultsCollectionCell
        
        guard let images = images else {
            return cell
        }
        
        Networker.shared.download(URL(string: images[indexPath.row].url)!) { (data, error) in
            guard let data = data else {
                return
            }
            
            let image = UIImage(data: data)!
            
            DispatchQueue.main.async {
                cell.set(image: image)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func onSearchEditingEnd(_ query: String) {
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
