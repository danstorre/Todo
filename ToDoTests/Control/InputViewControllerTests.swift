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
    
    func test_Save_UsesGeocoderToGetCoordinateFromAddress() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        
        let timestamp = 1456023600.0
        let date = Date(timeIntervalSince1970: timestamp)
        
        
        sut.titleTextField.text = "Foo"
        sut.dateTextField.text = dateFormatter.string(from: date)
        sut.locationTextField.text = "Bar"
        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
        sut.descriptionTextField.text = "Baz"
        
        
        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder
        
        
        sut.itemManager = ItemManager()
        
        sut.delegate = delegate
        sut.save()
        
        placemark = MockPlacemark()
        
        let coordinate = CLLocationCoordinate2DMake(37.3316851,
                                                    -122.0300674)
        placemark.mockCoordinate = coordinate
        
        let expectationDelegate = expectation(description: "delegateGetsCalled")

        delegate.completionHandler = {[unowned self] in
            XCTAssertTrue(self.delegate.didFinishedGetsCalled)
            let item = self.sut.itemManager?.itemAtIndex(0)
            let testItem = ToDoItem(title: "Foo",
                                           itemDescription: "Baz",
                                           timestamp: timestamp,
                                           location: Location(name: "Bar",
                                                              coordinate: coordinate))
            XCTAssertEqual(item, testItem)
            expectationDelegate.fulfill()
        }
        
        mockGeocoder.completionHandler?([placemark], nil)
        wait(for: [expectationDelegate], timeout: 12)
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

        mockInputViewController.delegate = delegate
        
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        
        
        
        let expectationDelegate = expectation(description: "delegateGetsCalled")
        delegate.completionHandler = {[unowned self, mockInputViewController] in
            XCTAssertTrue(self.delegate.didFinishedGetsCalled)
            expectationDelegate.fulfill()
        }
        mockInputViewController.save()
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
        
        wait(for: [expectationDelegate], timeout: 12)
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
        override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
            dismissGotCalled = true
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
