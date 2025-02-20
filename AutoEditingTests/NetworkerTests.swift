//
//  NetworkerTests.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import XCTest
@testable import AutoEditing

class NetworkerTests: XCTestCase {
    func testDownloadWithCaching() {
        let networker = Networker()
        
        let testUrl = URL(string: "https://testUrl.com")!
        let testData = "test data".data(using: .utf8)!
        
        URLProtocolMock.data = testData
        URLProtocol.registerClass(URLProtocolMock.self)
            
        // Should download with URLSession
        networker.download(testUrl) { data1, error1 in
            XCTAssertNotNil(data1)
            XCTAssertNil(error1)
            XCTAssertEqual(data1, testData)
                
            URLProtocolMock.data = nil
                
            // Should download with cache
            networker.download(testUrl) { data2, error2 in
                XCTAssertNotNil(data2)
                XCTAssertNil(error2)
                XCTAssertEqual(data2, testData)
            }
        }
    }
    
    func testDownloadFromDifferentUrls() {
        let networker = Networker()
        
        let testUrl1 = URL(string: "https://testUrl1.com")!
        let testData1 = "test data 1".data(using: .utf8)!
        
        let testUrl2 = URL(string: "https://testUrl2.com")!
        let testData2 = "test data 2".data(using: .utf8)!
        
        URLProtocolMock.data = testData1
        URLProtocol.registerClass(URLProtocolMock.self)
                
        networker.download(testUrl1) { data1, error1 in
            XCTAssertNotNil(data1)
            XCTAssertNil(error1)
            XCTAssertEqual(data1, testData1)
                
            URLProtocolMock.data = testData2
            
            networker.download(testUrl2) { data2, error2 in
                XCTAssertNotNil(data2)
                XCTAssertNil(error2)
                XCTAssertEqual(data2, testData2)
            }
        }
    }
}
