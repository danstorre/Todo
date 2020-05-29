//
//  APIClient.swift
//  ToDo
//
//  Created by Daniel Torres on 5/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

class APIClient {
    lazy var session: ToDoURLSession = URLSession.shared
    func loginUserWithName(_ username: String,
                           password: String,
                           completion: (Error?) -> Void) {
        let userNameQuery = URLQueryItem(name: "username", value: username)
        let passwordQuery = URLQueryItem(name: "password", value: password)
        let domainURL = URL(string: "https://awesometodos.com/")!
        var components = URLComponents(url: domainURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [userNameQuery, passwordQuery]
        components.path = "/login"
        guard let url = components.url else { fatalError() }
        let task = session.dataTask(with: url) { (data, response, error) -> Void
            in
        }
        task.resume()
    }
}

protocol ToDoURLSession {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession : ToDoURLSession {
}
