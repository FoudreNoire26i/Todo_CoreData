//
//  IconPickerTableViewController.swift
//  Todo_CoreData
//
//  Created by lpiem2 on 24/02/2021.
//

import UIKit

protocol SelectIconDelegate : class {
    func userSelectIcon(_ controller : IconPickerTableViewController, _ iconSelected : EnumTodoIcons)
}

class IconPickerTableViewController: UITableViewController {

    var delegate : SelectIconDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EnumTodoIcons.allCases.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnumTodoIconsListCell", for: indexPath)
        
        
        cell.textLabel?.text = EnumTodoIcons.allCases[indexPath.row].rawValue
        cell.imageView?.image = EnumTodoIcons.allCases[indexPath.row].image

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate!.userSelectIcon(self, EnumTodoIcons.allCases[indexPath.row])
    }

}
