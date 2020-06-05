//
//  ItemListDataProvider.swift
//  ToDo
//
//  Created by Daniel Torres on 5/22/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

enum Section: Int {
    case ToDo
    case Done
}

@objc protocol ItemManagerSettable {
    var itemManager: ItemManager? { get set }
}

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate, ItemManagerSettable {
    var itemManager: ItemManager?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "ItemCell",
                                                  for: indexPath) as! ItemCell
        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        let item: ToDoItem
        switch section {
        case .ToDo:
            item = itemManager.itemAtIndex(indexPath.row)
        case .Done:
            item = itemManager.doneItemAtIndex(indexPath.row)
        }
        cell.configCellWithItem(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let itemManager = itemManager else {
            return 0
        }
        guard let itemSection = Section(rawValue: section) else {
            fatalError()
        }
        let numberOfRows: Int
        switch itemSection {
        case .ToDo:
            numberOfRows = itemManager.toDoCount
        case .Done:
            numberOfRows = itemManager.doneCount }
        return numberOfRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        let buttonTitle: String
        switch section {
        case .ToDo:
            buttonTitle = "Check"
        case .Done:
            buttonTitle = "Uncheck"
        }
        return buttonTitle
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        switch section {
        case .ToDo:
            itemManager.checkItemAtIndex(indexPath.row)
        case .Done:
            itemManager.uncheckItemAtIndex(indexPath.row)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemSection = Section(rawValue: indexPath.section) else { fatalError() }
        switch itemSection {
        case .ToDo:
            NotificationCenter.default.post( name: NSNotification.Name(rawValue: "ItemSelectedNotification"), object: self, userInfo: ["index": indexPath.row])
           default:
               break
        }
    }
}
