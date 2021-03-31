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
    var listCategory : [Categorie] = []
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descrTextField: UITextField!
    @IBOutlet weak var creationDateTextView: UILabel!
    @IBOutlet weak var lastUpdateDateTextView: UILabel!
    
    var itemToEdit : Tache? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (itemToEdit != nil){
            titleTextField.text = itemToEdit!.titre
            descrTextField.text = itemToEdit!.desc
            itemToEdit!.categorie?.forEach({ (cat : Any) in
                listCategory.append((cat as! Categorie))
            })
            updateCategoryLabel()
            if (itemToEdit!.image?.data != nil){
                todoImageView.image = UIImage(data: itemToEdit!.image!.data!)
            } else {
                todoImageView.image = EnumTodoIcons.NoIcon.image
            }
            
        }
         updateDateLabels()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateDateLabels() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "fr_FR")
        
        if (itemToEdit != nil){
            creationDateTextView.text = dateFormatter.string(from: itemToEdit!.dateCreation!)
            lastUpdateDateTextView.text = dateFormatter.string(from: itemToEdit!.dateMaj!)
        } else {
            creationDateTextView.text = dateFormatter.string(from: Date())
            lastUpdateDateTextView.text = dateFormatter.string(from: Date())
        }
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
        if (itemToEdit != nil){
            DataManager.shared.updateTask(
                objet: itemToEdit!,
                titre: titleTextField.text ?? itemToEdit!.titre!,
                description: descrTextField.text ?? "No descr",
                listCategory: listCategory,
                dateMaj: Date(),
                checked: itemToEdit!.checked,
                data: todoImageView.image!.pngData()! ?? UIImage(named: "No icon")!.pngData()!
            )
        } else {
            let newTodo = DataManager.shared.addTask(
                titre: titleTextField.text ?? "No title",
                description: descrTextField.text ?? "No descr",
                listCategory: listCategory,
                data: todoImageView.image!.pngData()! ?? UIImage(named: "No icon")!.pngData()!
            )
        }
        delegate?.addTodoViewControllerDone(self)
    }
    
    
    @IBAction func categoryStepperValueChanged(_ sender: UIStepper) {
        if (listCategory.count < Int(sender.value)){
            let newText = newCategorieTextField.text
            if  (newText != nil && newText != "" && !listCategory.contains(where: { (cat : Categorie) -> Bool in
                return cat.titre == newText
            })){
                let newCat = DataManager.shared.addCategory(titre: newText!)
                listCategory.append(newCat)
            }
            //add cat
        } else if (listCategory.count > Int(sender.value)){
            let last = listCategory.popLast()
            DataManager.shared.deleteCategory(objet: last!)
            //remove cat
        }
        updateCategoryLabel()
    }
    
    func updateCategoryLabel(){
        if (listCategory.isEmpty){
            categorieStepper.value = 0
            categorieListLabel.text = "Aucune catégorie"
        } else {
            categorieListLabel.text = ""
            listCategory.forEach { (cat) in
                categorieListLabel.text! += "\(cat.titre!), "
            }
            categorieStepper.value = Double(listCategory.count)
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
        /*if (itemToEdit != nil){
            //todo : possible erreur
            DataManager.shared.addImage(data: iconSelected.image.pngData()!)
            //itemToEdit!.image!.data = iconSelected.image.pngData()
        }*/
        controller.dismiss(animated: true)
    }
}
