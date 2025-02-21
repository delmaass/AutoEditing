//
//  URL+ExtensionsTests.swift
//  AutoEditing
//
//  Created by Louis Delmas on 21/02/2025.
//

import XCTest
@testable import AutoEditing

class URLExtensionsTests: XCTestCase {
    func testURLAppendOneQueryItem() {
        var url = URL(string: "https://test.com")!
        
        url.appendQueryItem(name: "name", value: "value")
        
        XCTAssertEqual("https://test.com?name=value", url.absoluteString)
    }
    
    func testURLAppendMultipleQueryItems() {
        var url = URL(string: "https://test.com")!
        
        url.appendQueryItem(name: "name1", value: "value1")
        url.appendQueryItem(name: "name2", value: "value2")
        
        XCTAssertEqual("https://test.com?name1=value1&name2=value2", url.absoluteString)
    }
    
    func testURLAppendQueryItemWithMustBeEncodedCharacters() {
        var url = URL(string: "https://test.com")!
        
        url.appendQueryItem(name: "name1", value: "value1&value1")
        url.appendQueryItem(name: "name2", value: "value2+value2")
        url.appendQueryItem(name: "name3", value: "value3 value3")
        url.appendQueryItem(name: "name4", value: "value4?value4")
        url.appendQueryItem(name: "name4", value: "value5=value5")
        
        XCTAssertEqual("https://test.com?name1=value1%26value1&name2=value2%2Bvalue2&name3=value3%20value3&name4=value4%3Fvalue4&name4=value5%3Dvalue5", url.absoluteString)
    }
}
