//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Daniel Torres on 5/21/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
class ItemListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate)!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
}
