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
    
    override func setUp() {
        super.setUp()
        mockDataSource = ImageDataSourceMock()
        vc = SearchViewController(dataSource: mockDataSource)
    }
    
    override func tearDown() {
        vc = nil
        mockDataSource = nil
        super.tearDown()
    }
    
    func testImageSelection() {
        let image1 = Image(id: "1", url: "url1")
        let image2 = Image(id: "2", url: "url2")
        vc.images = [image1, image2]
        
        vc.onToggleSelected(image1.id, selected: true)
        
        XCTAssertEqual(vc.selectedImages.count, 1)
        XCTAssertEqual(vc.selectedImages.first?.id, "1")
        
        vc.onToggleSelected(image2.id, selected: true)
        
        XCTAssertEqual(vc.selectedImages.count, 2)
        
        vc.onToggleSelected(image1.id, selected: false)
        
        XCTAssertEqual(vc.selectedImages.count, 1)
        XCTAssertEqual(vc.selectedImages.first?.id, "2")
    }
    
    func testSearchFetch() {
        mockDataSource.mockImages = [Image(id: "1", url: "url1")]
        
        vc.onSearchEditingEnd("test")
        
        XCTAssertEqual(self.vc.images.count, 1)
        XCTAssertEqual(self.vc.images.first?.id, "1")
    }
}
