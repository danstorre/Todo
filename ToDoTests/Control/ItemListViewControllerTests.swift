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
    
    var sut: ItemListViewController!
    var window: UIWindow!
    
    override func setUpWithError() throws {
        window = UIWindow()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard
            .instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController)
        _ = sut.view
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_TableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testViewDidLoad_ShouldSetTableViewDataSource() {
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }
    
    func testViewDidLoad_ShouldSetTableViewDelegate() {
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func testViewDidLoad_ShouldSetDelegateAndDataSourceToTheSameObject() { XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider,
                                                                                          sut.tableView.delegate as? ItemListDataProvider)
    }
    
    func testItemListViewController_HasAddBarButtonWithSelfAsTarget() { XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.target as?
        UIViewController, sut)
    }
    
    func testAddItem_PresentsAddItemViewController() {
        performTestPresentingAnInputViewcontroller_WhenPerformingActionNavigation()
        
        let inputViewController = sut.presentedViewController as! InputViewController
        XCTAssertNotNil(inputViewController.titleTextField)
    }
    
    func testItemListVC_SharesItemManagerWithInputVC() {
        performTestPresentingAnInputViewcontroller_WhenPerformingActionNavigation()
        let inputViewController = sut.presentedViewController as! InputViewController
        
        guard let inputItemManager = inputViewController.itemManager else { XCTFail(); return }
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }
    
    func testViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func testViewWillAppear_reloadsTableView(){
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        XCTAssertTrue(mockTableView.didCalledReloadData)
    }
    
    func performTestPresentingAnInputViewcontroller_WhenPerformingActionNavigation(){
        XCTAssertNil(sut.presentedViewController)
        guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail(); return }
        window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        window.rootViewController = sut
        
        if let action = addButton.action {
            sut.perform(action, with: addButton)
        }
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
    }
    
    class MockTableView: UITableView{
        var didCalledReloadData = false
        override func reloadData() {
            didCalledReloadData = true
        }
    }
}
