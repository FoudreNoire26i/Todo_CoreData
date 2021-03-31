//
//  TodosListTableViewController.swift
//  Todo_CoreData
//
//  Created by lpiem2 on 24/02/2021.
//

import UIKit

class TodosListTableViewController: UITableViewController {
    
    var listTodos : [Tache] = []
    
    
    var documentDirectory: URL {
        get {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        listTodos = DataManager.shared.getTache()
        print(documentDirectory)
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
        } else if segue.identifier == "editTodoItemSegue" {
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddTodoTableViewController
            dest.itemToEdit = (sender as! TodoTableViewCell).todo
            dest.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTodos.count 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier:"TodoItemCell", for : indexPath) as! TodoTableViewCell
        let item = listTodos[indexPath.row]
        cell.todo = item
        cell.setUI(title: item.titre!, subtitle: item.desc!, image: UIImage(named: "Appointments"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //checklist.items.remove(at: indexPath.row)
        DataManager.shared.deleteTask(objet: listTodos[indexPath.row])
        listTodos.remove(at: indexPath.row)
        //saveChecklist()
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}

extension TodosListTableViewController : AddTodoDelegate {
    func addTodoViewControllerDidCancel(_ controller: AddTodoTableViewController) {
        dismiss(animated: true) {
            print("user cancel adding todo")
        }
    }
    
    func addTodoViewControllerDone(_ controller: AddTodoTableViewController) {
        listTodos = DataManager.shared.getTache()
        tableView.reloadData()
        dismiss(animated: true) {
            print("user added todo")
        }
    }
}
