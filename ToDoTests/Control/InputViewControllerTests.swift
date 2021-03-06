//
//  InputViewControllerTests.swift
//  ToDoTests
//
//  Created by Daniel Torres on 5/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController)
        _ = sut.view
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_HasTitleTextField() {
        XCTAssertNotNil(sut.titleTextField)
    }
    
    func test_HasDateTextField() {
        XCTAssertNotNil(sut.dateTextField)
    }
    
    func test_HasLocationTextField() {
        XCTAssertNotNil(sut.locationTextField)
    }
    
    func test_HasAddressTextField() {
        XCTAssertNotNil(sut.addressTextField)
    }
    
    func test_HasDescriptionTextField() {
        XCTAssertNotNil(sut.descriptionTextField)
    }
    
    func test_HasSaveButton() {
        XCTAssertNotNil(sut.saveButton)
    }
    
    func test_HasCancelButton() {
        XCTAssertNotNil(sut.cancelButton)
    }
    
    func xtest_Save_UsesGeocoderToGetCoordinateFromAddress() {
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.dateTextField.text = "02/22/2016"
        mockInputViewController.locationTextField.text = "Office"
        
        mockInputViewController.addressTextField.text = "Infinite Loop 1, Cupertino"
        
        mockInputViewController.descriptionTextField.text = "Test Description"
        let mockGeocoder = MockGeocoder()
        mockInputViewController.geocoder = mockGeocoder
        mockInputViewController.itemManager = ItemManager()
        let expectation1 = expectation(description: "DISMISS")
        
        mockInputViewController.completionHandler = {
            expectation1.fulfill()
        }
        mockInputViewController.save()
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        let item = mockInputViewController.itemManager?.itemAtIndex(0)
        let testItem = ToDoItem(title: "Test Title",
                                itemDescription: "Test Description",
                                timestamp: 1456110000.0,
                                location: Location(name: "Office", coordinate: coordinate))
        XCTAssertEqual(item, testItem)
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        
        
        guard let actions = saveButton.actions(
            forTarget: sut,
            forControlEvent: .touchUpInside) else {
                XCTFail();
                return
        }
        
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    func test_GeocoderWorksAsExpected() {
        let expectationGeo = expectation(description: "Wait for geocode")
        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") { (placemarks, error) -> Void in
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return }
            guard let longitude = coordinate?.longitude else { XCTFail()
                return }
            XCTAssertEqual(latitude, 37.331656, accuracy: 0.000001)
            XCTAssertEqual(longitude, -122.0301426, accuracy: 0.000001)
            expectationGeo.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    let delegate = MockDelegate()
    
    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        
        let expectation1 = expectation(description: "bla")
        
        mockInputViewController.completionHandler = {
            expectation1.fulfill()
        }
        mockInputViewController.save()
        wait(for: [expectation1], timeout: 12)
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }
    
}

extension InputViewControllerTests {
    
    class MockDelegate: InputDelegateController {
        var didFinishedGetsCalled = false
        var completionHandler: (()->())?
        func didFinish() {
            didFinishedGetsCalled = true
            completionHandler?()
        }
    }
    
    class MockInputViewController : InputViewController {
        var dismissGotCalled = false
        var completionHandler: (() -> Void)?
        override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
            dismissGotCalled = true
            completionHandler?()
        }
    }
    
    
    class MockGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler }
    }
    class MockPlacemark : CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}
