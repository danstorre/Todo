//
//  ToDoItemTests.swift
//  ToDoTests
//
//  Created by Daniel Torres on 5/20/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoItemTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
   func testInit_ShouldTakeTitle() {
        let item = ToDoItem(title: "Test title")
        XCTAssertEqual(item.title,
                       "Test title",
                       "Initializer should set the item title")
    }
    
    func testInit_ShouldSetTitleAndDescription() {
        let item = ToDoItem(title: "Test title",
                            itemDescription: "Test description")
        XCTAssertEqual(item.itemDescription,
                       "Test description",
                       "Initializer should set the item description")
    }
    func testInit_ShouldSetTitleAndDescriptionAndTimestamp() {
        let item = ToDoItem(title: "Test title",
                            itemDescription: "Test description",
                            timestamp: 0.0)
        XCTAssertEqual(0.0,
                       item.timestamp,
                       "Initializer should set the timestamp")
    }
    func testInit_ShouldSetTitleAndDescriptionAndTimestampAndLocation() {
        let location = Location(name: "Test name")
        let item = ToDoItem(title: "Test title",
                            itemDescription: "Test description",
                            timestamp: 0.0,
                            location: location)
        XCTAssertEqual(location.name,
                       item.location?.name,
                       "Initializer should set the location")
    }
    
    func testWhenOneLocationIsNilAndTheOtherIsnt_ShouldBeNotEqual() {
        var firstItem = ToDoItem(title: "First title",
                                 itemDescription: "First description",
                                 timestamp: 0.0,
                                 location: nil)
        var secondItem = ToDoItem(title: "First title",
                                  itemDescription: "First description",
                                  timestamp: 0.0,
                                  location: Location(name: "Office"))
        XCTAssertNotEqual(firstItem, secondItem)
        firstItem = ToDoItem(title: "First title",
                             itemDescription: "First description",
                             timestamp: 0.0,
                             location: Location(name: "Home"))
        secondItem = ToDoItem(title: "First title",
                              itemDescription: "First description",
                              timestamp: 0.0,
                              location: nil)
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func testWhenTimestampDifferes_ShouldBeNotEqual() {
        let firstItem = ToDoItem(title: "First title",
                                 itemDescription: "First description",
                                 timestamp: 1.0)
        let secondItem = ToDoItem(title: "First title",
                                  itemDescription: "First description",
                                  timestamp: 0.0)
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func testWhenDescriptionDifferes_ShouldBeNotEqual() {
        let firstItem = ToDoItem(title: "First title", itemDescription: "First description")
        let secondItem = ToDoItem(title: "First title", itemDescription: "Second description")
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func testWhenTitleDifferes_ShouldBeNotEqual() {
        let firstItem = ToDoItem(title: "First title")
        let secondItem = ToDoItem(title: "Second title")
        XCTAssertNotEqual(firstItem, secondItem)
    }

    func test_HasPlistDictionaryProperty() {
        let item = ToDoItem(title: "First")
        let dictionary = item.plistDict
        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is NSDictionary)
    }
    
    func test_CanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Home")
        let item = ToDoItem(title: "The Title",
                            itemDescription: "The Description", timestamp: 1.0,
                            location: location)
        let dict = item.plistDict
        let recreatedItem = ToDoItem(dict: dict)
        XCTAssertEqual(item, recreatedItem)
    }

}
