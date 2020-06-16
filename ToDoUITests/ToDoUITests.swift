//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Daniel Torres on 6/5/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest

class ToDoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func xtestExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()
        let titleTextField = app.textFields["Title"]
        titleTextField.tap()
        titleTextField.typeText("Meeting")
        let dateTextField = app.textFields["Date"]
        dateTextField.tap()
        dateTextField.typeText("02/22/2016")
        let locationNameTextField = app.textFields["Location Name"]
        locationNameTextField.tap()
        locationNameTextField.typeText("Office")
        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        addressTextField.typeText("Infinite Loop 1, Cupertino")
        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("Bring iPad")
        
        
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Save"].tap()
    }
}
