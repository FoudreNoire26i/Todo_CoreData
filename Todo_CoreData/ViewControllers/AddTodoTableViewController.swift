//
//  TableViewController.swift
//  Todo_CoreData
//
//  Created by lpiem2 on 24/02/2021.
//

import UIKit

protocol AddTodoDelegate : class{
    func addTodoViewControllerDidCancel(_ controller: AddTodoTableViewController)
    func addTodoViewControllerDone(_ controller: AddTodoTableViewController)
}

class AddTodoTableViewController: UITableViewController {
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var todoImageView: UIImageView!
    
    var delegate : TodosListTableViewController?
    
    @IBOutlet weak var categorieListLabel: UILabel!
    @IBOutlet weak var categorieStepper: UIStepper!
    @IBOutlet weak var newCategorieTextField: UITextField!
    var listCategory : [String] = []
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descrTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectDefaultImageSegue" {
            let dest = segue.destination as! IconPickerTableViewController
            dest.delegate = self
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        delegate?.addTodoViewControllerDidCancel(self)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        DataManager.shared.addTask(titre: titleTextField.text ?? "No title", description: descrTextField.text ?? "No descr")
        delegate?.addTodoViewControllerDone(self)
    }
    
    
    @IBAction func categoryStepperValueChanged(_ sender: UIStepper) {
        if (listCategory.count < Int(sender.value)){
            if  (newCategorieTextField.text != nil && newCategorieTextField.text != "" && !listCategory.contains(newCategorieTextField.text!)){
                listCategory.append(newCategorieTextField.text!)
            }
            //add cat
        } else if (listCategory.count > Int(sender.value)){
            listCategory.popLast()
            //remove cat
        }
        updateCategoryLabel()
    }
    
    func updateCategoryLabel(){
        if (listCategory.isEmpty){
            categorieListLabel.text = "Aucune catégorie"
        } else {
            categorieListLabel.text = ""
            listCategory.forEach { (cat) in
                categorieListLabel.text! += "\(cat), "
            }
        }
    }
}

extension AddTodoTableViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let newString = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: string)
        saveBarButtonItem.isEnabled = newString.count > 0
        return true
    }
}

extension AddTodoTableViewController : SelectIconDelegate {
    func userSelectIcon(_ controller: IconPickerTableViewController, _ iconSelected: EnumTodoIcons) {
        todoImageView.image = iconSelected.image
        controller.dismiss(animated: true)
    }
}
