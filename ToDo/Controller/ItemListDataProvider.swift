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


class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
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
}
