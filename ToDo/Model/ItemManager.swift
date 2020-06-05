//
//  ItemManager.swift
//  ToDo
//
//  Created by Daniel Torres on 5/20/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class ItemManager: NSObject {
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()
    
    var toDoPathURL: NSURL {
        let fileURLs = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else { print("Something went wrong. Documents url could not be found")
            fatalError()
        }
        return (documentURL as NSURL).appendingPathComponent("toDoItems.plist")! as NSURL
    }
    
    override init() {
        super.init()
        if let nsToDoItems = NSArray(contentsOf: toDoPathURL as URL) {
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! NSDictionary) {
                    toDoItems.append(toDoItem)
                }
            }
        }

        NotificationCenter.default.addObserver( self,
                                                selector: #selector(save),
                                                name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }
    
    @objc func save() {
        var nsToDoItems = [AnyObject]()
        for item in toDoItems { nsToDoItems.append(item.plistDict)
        }
        if nsToDoItems.count > 0 {
            (nsToDoItems as NSArray).write(to: toDoPathURL as URL,
                                           atomically: true)
        } else {
            do {
                try FileManager.default.removeItem(at: toDoPathURL as URL)
            } catch {
                print(error)
            }
        }
    }
    
    func addItem(_ item: ToDoItem) {
        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }
    
    func itemAtIndex(_ index: Int) -> ToDoItem {
        return toDoItems[index]
    }
    
    func checkItemAtIndex(_ index: Int) {
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }
    func uncheckItemAtIndex(_ index: Int) {
        let item = doneItems.remove(at: (index))
        toDoItems.append(item)
    }
    func doneItemAtIndex(_ index: Int) -> ToDoItem {
        return doneItems[index]
    }
    func removeAllItems() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
}
