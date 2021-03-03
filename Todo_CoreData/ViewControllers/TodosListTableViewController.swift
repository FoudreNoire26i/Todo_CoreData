//
//  TodosListTableViewController.swift
//  Todo_CoreData
//
//  Created by lpiem2 on 24/02/2021.
//

import UIKit



class TodosListTableViewController: UITableViewController {
    
    var listTodos : [Tache] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTodo" {
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddTodoTableViewController
            dest.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTodos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "id")
        cell.largeContentTitle = listTodos[indexPath.row].titre
        return cell
    }

}

extension TodosListTableViewController : AddTodoDelegate {
    func addTodoViewControllerDidCancel(_ controller: AddTodoTableViewController) {
        dismiss(animated: true) {
            print("user cancel adding todo")
        }
    }
    
    func addTodoViewControllerDone(_ controller: AddTodoTableViewController, _ item: String) {
        dismiss(animated: true) {
            print("user added todo")
        }
    }
    
    
}
