//
//  DataManager.swift
//  Todo_CoreData
//
//  Created by LPIEM on 24/02/2021.
//

import UIKit
import CoreData

protocol DataManagerProtocol {
    
    func addTask(titre: String,description: String, listCategory : [Categorie]) -> Tache
    func addCategory(titre: String) -> Categorie
    func addTaskUpdated(titre: String, description: String, myCreationDate: Date, dateMaj: Date, listCategory : [Categorie]?, checked : Bool)
    
    func deleteTask(objet: Tache)
    func deleteCategory(objet: Categorie)
    
    func updateTask(objet: Tache, titre: String,description: String, listCategory : [Categorie]?, dateMaj: Date?, checked : Bool)
    
}

class DataManager{
    static let shared = DataManager()
    
    var persistantContainer: NSPersistentContainer {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    private init(){}
    
    func getData(){
        let managedContext = persistantContainer.viewContext
        let fetchRequest = NSFetchRequest<Tache>(entityName: "Tache")
        
        do{
            let result: [Tache] = try managedContext.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func getTache() -> [Tache] {
        let managedContext = persistantContainer.viewContext
        let fetchRequest = NSFetchRequest<Tache>(entityName: "Tache")
        let sort = NSSortDescriptor(key: "dateMaj", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do{
            let result: [Tache] = try managedContext.fetch(fetchRequest)
            return result
        }catch{
            print(error.localizedDescription)
            return []
        }
        
    }
    
    func saveData(){
        let context = persistantContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension DataManager:DataManagerProtocol{
    
    //todo : virer et remplacer addtask par cette fct
    func addTaskUpdated(titre: String, description: String, myCreationDate: Date, dateMaj: Date,  listCategory : [Categorie]?, checked :Bool) {
        let managedContext = persistantContainer.viewContext
        let item = Tache(context: managedContext)
        item.titre = titre
        item.desc = description
        item.dateCreation = myCreationDate
        item.dateMaj = dateMaj
        item.checked = checked
        listCategory?.forEach { (cat : Categorie) in
            item.addToCategorie(cat)
        }
        
        saveData()
    }
    
    
    func updateTask(objet: Tache, titre: String, description: String, listCategory : [Categorie]?, dateMaj: Date?,  checked : Bool) {
        let managedContext = persistantContainer.viewContext
        let fetchRequest: NSFetchRequest<Tache> = Tache.fetchRequest()
        
        let predicate = NSPredicate(format: "titre == %@",objet.titre!)
        fetchRequest.predicate = predicate
        
        do{
            
            let result: [Tache] = try managedContext.fetch(fetchRequest)
            
            
            addTaskUpdated(titre: titre, description: description, myCreationDate: objet.dateCreation!, dateMaj: dateMaj ?? Date(), listCategory: listCategory, checked: checked)
            
            for object in result {
                deleteTask(objet: object)
            }
            
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func addTask(titre: String , description: String, listCategory : [Categorie]) -> Tache{
        let managedContext = persistantContainer.viewContext
        let item = Tache(context: managedContext)
        item.titre = titre
        item.desc = description
        item.checked = false
        
        item.dateCreation = Date()
        item.dateMaj = Date()
        
        listCategory.forEach { (cat : Categorie) in
            item.addToCategorie(cat)
        }
        
        saveData()
        return item
    }
    
    func addCategory(titre: String) -> Categorie{
        let managedContext = persistantContainer.viewContext
        let item = Categorie(context: managedContext)
        item.titre = titre
        item.dateCreation = Date()
        saveData()
        return item
    }
    
    func deleteTask(objet: Tache){
        let managedContext = persistantContainer.viewContext
        managedContext.delete(objet)
        saveData()

    }
    
    func deleteCategory(objet: Categorie){
        let managedContext = persistantContainer.viewContext
        managedContext.delete(objet)
        saveData()

    }
    
}

