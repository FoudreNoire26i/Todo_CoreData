//
//  TableViewController.swift
//  Todo_CoreData
//
//  Created by lpiem2 on 24/02/2021.
//

import UIKit

protocol AddTodoDelegate : class{
    func addTodoViewControllerDidCancel(_ controller: AddTodoTableViewController)
    func addTodoViewControllerDone(_ controller: AddTodoTableViewController, _ item: String)
}

class AddTodoTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
}

extension AddTodoTableViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let newString = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: string)
        //doneButton.isEnabled = newString.count > 0
        return true
    }
}
