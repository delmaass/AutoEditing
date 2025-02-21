//
//  SearchViewControllerTests.swift
//  AutoEditing
//
//  Created by Louis Delmas on 21/02/2025.
//

import XCTest
@testable import AutoEditing

class SearchViewControllerTests: XCTestCase {
    var vc: SearchViewController!
    var mockDataSource: ImageDataSourceMock!
    var mockViewInstance: SearchViewMock!
    
    override func setUp() {
        super.setUp()
        mockDataSource = ImageDataSourceMock()
        mockViewInstance = SearchViewMock()
        vc = SearchViewController(dataSource: mockDataSource, viewInstance: mockViewInstance)
        vc.loadView()
    }
    
    override func tearDown() {
        vc = nil
        mockDataSource = nil
        mockViewInstance = nil
        super.tearDown()
    }
    
    func testImageSelection() {
        let image1 = Image(id: "1", url: "url1")
        let image2 = Image(id: "2", url: "url2")
        vc.images = [image1, image2]
        
        vc.onToggleSelected(image1.id, selected: true)
        
        XCTAssertEqual(vc.selectedImages.count, 1)
        XCTAssertEqual(vc.selectedImages.first?.id, "1")
        XCTAssertEqual(vc.images.count, 1)
        XCTAssertEqual(vc.images.first?.id, "2")
        
        vc.onToggleSelected(image2.id, selected: true)
        
        XCTAssertEqual(vc.selectedImages.count, 2)
        XCTAssertEqual(vc.images.count, 0)
        
        vc.onToggleSelected(image1.id, selected: false)
        
        XCTAssertEqual(vc.selectedImages.count, 1)
        XCTAssertEqual(vc.selectedImages.first?.id, "2")
        XCTAssertEqual(vc.images.count, 1)
        XCTAssertEqual(vc.images.first?.id, "1")
    }
    
    func testSearchFetch() {
        mockDataSource.mockImages = [Image(id: "1", url: "url1")]
        
        vc.onSearchEditingEnd("test")
        
        XCTAssertEqual(self.vc.images.count, 1)
        XCTAssertEqual(self.vc.images.first?.id, "1")
    }
    
    func testPaginationWithNewImages() {
        // Page 0
        let image1 = Image(id: "1", url: "url1")
        let image2 = Image(id: "2", url: "url2")
        vc.images = [image1, image2]
        
        // Page 1
        let image3 = Image(id: "3", url: "url3")
        let image4 = Image(id: "4", url: "url4")
        
        mockDataSource.mockImages = [image3, image4]
        mockViewInstance.reloadCollectionDataCallCount = 0
        
        // Last item reached -> fetch new images
        vc.collectionView(willDisplayItemAt: IndexPath(row: 1, section: 0), query: "test")
        
        // Check that fetch has occurred and new images were added
        XCTAssertEqual(vc.images.count, 4)
        XCTAssertEqual(vc.images[2].id, "3")
        XCTAssertEqual(vc.images[3].id, "4")
        XCTAssertEqual(mockViewInstance.reloadCollectionDataCallCount, 1, "reloadCollectionData should be called once")
    }
    
    func testPaginationWithoutNewImages() {
        let image1 = Image(id: "1", url: "url1")
        let image2 = Image(id: "2", url: "url2")
        vc.images = [image1, image2]
        
        mockDataSource.mockImages = []
        mockViewInstance.reloadCollectionDataCallCount = 0
        
        vc.collectionView(willDisplayItemAt: IndexPath(row: 1, section: 0), query: "test")
        
        XCTAssertEqual(vc.images.count, 2)
        XCTAssertEqual(mockViewInstance.reloadCollectionDataCallCount, 0, "reloadCollectionData should not be called when no new images")
    }
}
