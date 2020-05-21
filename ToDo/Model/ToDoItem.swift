//
//  ToDoItem.swift
//  ToDo
//
//  Created by Daniel Torres on 5/20/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

struct ToDoItem {
    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?
    init(title: String,
         itemDescription: String? = nil,
         timestamp: Double? = nil,
         location: Location? = nil) {
            self.title = title
            self.itemDescription = itemDescription
            self.timestamp = timestamp
            self.location = location
    }
}


extension ToDoItem: Equatable {
    static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        if lhs.location?.name != rhs.location?.name {
            return false
        }
        return true
    }
}
