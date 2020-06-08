//
//  InputViewController.swift
//  ToDo
//
//  Created by Daniel Torres on 5/27/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import CoreLocation

extension ItemListViewController: InputDelegateController{
    func didFinish() {
        tableView.reloadData()
    }
}

protocol InputDelegateController: class {
    func didFinish()
}

class InputViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    
    weak var delegate: InputDelegateController?
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(hideTexfieldFirstResponder)))
        
        
    }
    
    @objc
    func hideTexfieldFirstResponder(){
        let firsResponser = self.view.subviews[0].subviews.first { (view) -> Bool in
            return view.isFirstResponder
        }
        firsResponser?.resignFirstResponder()
    }

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    @IBAction func save() {
        guard let titleString = titleTextField.text, titleString.count > 0 else { return }
        let date: Date?
        if let dateText = self.dateTextField.text, dateText.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }
        
        let descriptionString: String?
        if let count = descriptionTextField.text?.count,
            count > 0 {
            descriptionString = descriptionTextField.text
        } else {
            descriptionString = nil
        }
        if let locationName = locationTextField.text,
            locationName.count > 0 {
            if let address = addressTextField.text, address.count > 0 {
                geocoder.geocodeAddressString(address) {
                    [unowned self] (placeMarks, error) -> Void in
                    let placeMark = placeMarks?.first
                    let item = ToDoItem(title: titleString,
                                        itemDescription: descriptionString,
                                        timestamp: date?.timeIntervalSince1970,
                                        location: Location(name: locationName,
                                                           coordinate: placeMark?.location?.coordinate))
                    self.itemManager?.addItem(item)
                    
                    DispatchQueue.main.async {
                        self.delegate?.didFinish()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                return
            }
        }
        let item = ToDoItem(title: titleString,
                            itemDescription: descriptionString,
                            timestamp: date?.timeIntervalSince1970,
                            location: nil)
        itemManager?.addItem(item)
        delegate?.didFinish()
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
