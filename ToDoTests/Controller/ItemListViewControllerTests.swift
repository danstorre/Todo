//
//  ItemListViewControllerTests.swift
//  ToDoTests
//
//  Created by Daniel Torres on 5/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_TableViewIsNotNilAfterViewDidLoad() {
        let sut = ItemListViewController()
        _ = sut.view
        XCTAssertNotNil(sut.tableView)
    }

}
