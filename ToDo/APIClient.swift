//
//  APIClient.swift
//  ToDo
//
//  Created by Daniel Torres on 5/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

enum WebserviceError : Error {
    case DataEmptyError
    case ResponseError
}

class APIClient {
    lazy var session: ToDoURLSession = URLSession.shared
    var keychainManager: KeychainAccessible?
    func loginUserWithName(_ username: String,
                           password: String,
                           completion: @escaping (Error?) -> Void) {
        let userNameQuery = URLQueryItem(name: "username", value: username)
        let passwordQuery = URLQueryItem(name: "password", value: password)
        let domainURL = URL(string: "https://awesometodos.com/")!
        var components = URLComponents(url: domainURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [userNameQuery, passwordQuery]
        components.path = "/login"
        guard let url = components.url else { fatalError() }
        let task = session.dataTask(with: url) { (data, response, error) -> Void
            in
            if error != nil {
                completion(WebserviceError.ResponseError)
                return
            }

            if let theData = data {
                do {
                    let responseDict = try JSONSerialization
                        .jsonObject(with: theData, options: []) as! [String: Any]
                    let token = responseDict["token"] as! String
                    self.keychainManager?.setPassword(password: token,
                                                      account: "token")
                } catch {
                    completion(error)
                }
            } else {
                completion(WebserviceError.DataEmptyError)
            }
            
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
