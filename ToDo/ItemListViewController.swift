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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goToDetail(_:)), name:  NSNotification.Name(rawValue: "ItemSelectedNotification"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func goToDetail(_ obj: AnyObject){
        guard let notification = obj as? NSNotification,
            let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int else {
            return
        }
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController")
        as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            present(nextViewController, animated: true, completion: nil)
        }
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
