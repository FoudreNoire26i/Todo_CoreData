//
//  DataManager.swift
//  Todo_CoreData
//
//  Created by LPIEM on 24/02/2021.
//

import UIKit
import CoreData

protocol DataManagerProtocol {
    
    func addTask(titre: String,description: String)
    func addCategory(titre: String)
    
    func deleteTask(objet: Tache)
    func deleteCategory(objet: Categorie)
    
}

class DataManager{
    
    var persistantContainer: NSPersistentContainer {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    
    func addTask(titre: String ,description: String){
        let managedContext = persistantContainer.viewContext
        let item = Tache(context: managedContext)
        item.titre = titre
        item.desc = description
        item.dateCreation = Date()
        
    }
    
    func addCategory(titre: String){
        let managedContext = persistantContainer.viewContext
        let item = Categorie(context: managedContext)
        item.titre = titre
    }
    
    func deleteTask(objet: Tache){
        let managedContext = persistantContainer.viewContext
        managedContext.delete(objet)
    }
    
    func deleteCategory(objet: Categorie){
        let managedContext = persistantContainer.viewContext
        managedContext.delete(objet)
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
