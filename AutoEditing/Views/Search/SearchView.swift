//
//  SearchView.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit
import SnapKit

protocol SearchViewDelegate: AnyObject {
    func onSearchEditingEnd(_ query: String)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func onToggleSelected(_ cellIndexPath: IndexPath, selected: Bool)
}

class SearchView: UIView {
    weak var delegate: SearchViewDelegate?
    private let searchBar = UISearchBar()
    private var collection: UICollectionView?
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .lightGray
        searchBar.placeholder = "Search for images..."
        searchBar.searchTextField.addTarget(self, action: #selector(onSearchEditingEnd), for: .editingDidEnd)
        searchBar.searchTextField.addTarget(self, action: #selector(dismissKeyboard), for: .primaryActionTriggered)
        addSubview(searchBar)
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumInteritemSpacing = 8
        collectionLayout.minimumLineSpacing = 8
        
        let totalWidth = UIScreen.main.bounds.width
        let paddingSpace = collectionLayout.sectionInset.left + collectionLayout.sectionInset.right + collectionLayout.minimumInteritemSpacing
        let availableWidth = totalWidth - paddingSpace - 32
        let itemWidth = availableWidth / 2
            
        collectionLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection!.delegate = self
        collection!.dataSource = self
        collection!.register(SearchResultsCollectionCell.self, forCellWithReuseIdentifier: "SearchResultsCollectionCell")
        collection!.backgroundColor = .clear
        addSubview(collection!)
        
        button.isEnabled = false
        button.backgroundColor = .white
        button.setTitle("Continue (0/2)", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.blue.withAlphaComponent(0.4), for: .disabled)
        button.isUserInteractionEnabled = true
        addSubview(button)
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(8)
        }
        
        collection!.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func onSearchEditingEnd() {
        guard let query = searchBar.text else {
            return
        }
        
        delegate?.onSearchEditingEnd(query)
    }
    
    public func updateButton(count: Int) {
        button.setTitle("Continue (\(count)/2)", for: .normal)
        button.isEnabled = count >= 2
    }
    
    public func reloadCollectionData() {
        collection?.reloadData()
    }
}

extension SearchView: UICollectionViewDelegate {
    
}

extension SearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = delegate?.collectionView(collectionView, cellForItemAt: indexPath) as? SearchResultsCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        return cell
    }
}

extension SearchView: SearchResultsCollectionCellDelegate {
    func onToggleSelected(_ cell: SearchResultsCollectionCell, selected: Bool) {
        guard let indexPath = collection?.indexPath(for: cell) else {
            return
        }
        
        delegate?.onToggleSelected(indexPath, selected: selected)
    }
}

@available(iOS 17, *)
#Preview {
    SearchView()
}
