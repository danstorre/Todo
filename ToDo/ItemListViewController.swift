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
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    let itemManager = ItemManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider.itemManager = itemManager
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController")
        as? InputViewController {
            nextViewController.itemManager = itemManager
            nextViewController.delegate = self
            present(nextViewController, animated: true, completion: nil)
        }
    }
}
