//
//  APIClientTests.swift
//  ToDoTests
//
//  Created by Daniel Torres on 5/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import ToDo

class APIClientTests: XCTestCase {
    var sut: APIClient!
    var mockURLSession: MockURLSession!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = APIClient()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLogin_MakesRequestWithUsernameAndPassword() {
        let completion = { (error: Error?) in }
        sut.loginUserWithName("dasdöm",
                              password: "%&34",
                              completion: completion)
        XCTAssertNotNil(mockURLSession.completionHandler)
        
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = NSURLComponents(url: url,
                                            resolvingAgainstBaseURL: true)
        
        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
        XCTAssertEqual(urlComponents?.path, "/login")
        
        let allowedCharacters = NSCharacterSet(charactersIn: "/%&=?$#+- ~@<>|\\*,.()[]{}^!").inverted
        guard let expectedUsername = "dasdöm".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        guard let expectedPassword = "%&34".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        XCTAssertEqual(urlComponents?.percentEncodedQuery, "username=\(expectedUsername)&password=\(expectedPassword)")
    }
    
    func testLogin_CallsResumeOfDataTask() {
        let completion = { (error: Error?) in }
        sut.loginUserWithName("dasdom",
                              password: "1234", completion: completion)
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }
}

extension APIClientTests {
    class MockURLSession: ToDoURLSession {
        typealias Handler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: Handler?
        var url: URL?
        var dataTask = MockURLSessionDataTask()
        func dataTask(with url: URL,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            self.completionHandler = completionHandler
            return dataTask
        }
    }
    
    class MockURLSessionDataTask : URLSessionDataTask {
        var resumeGotCalled = false
        override func resume() {
            resumeGotCalled = true
        }
    }
}
