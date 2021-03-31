//
//  DataManager.swift
//  Todo_CoreData
//
//  Created by LPIEM on 24/02/2021.
//

import UIKit
import CoreData

protocol DataManagerProtocol {
    
    func addTask(titre: String,description: String) -> Tache
    func addCategory(titre: String) -> Categorie
    func addTaskUpdated(titre: String, description: String, myCreationDate: Date)
    
    func deleteTask(objet: Tache)
    func deleteCategory(objet: Categorie)
    
    func updateTask(objet: Tache, titre: String,description: String)
    
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
    func addTaskUpdated(titre: String, description: String, myCreationDate: Date) {
        let managedContext = persistantContainer.viewContext
        let item = Tache(context: managedContext)
        item.titre = titre
        item.desc = description
        item.dateCreation = myCreationDate
        saveData()
    }
    
    
    func updateTask(objet: Tache, titre: String, description: String) {
        let managedContext = persistantContainer.viewContext
        let fetchRequest: NSFetchRequest<Tache> = Tache.fetchRequest()
        
        let predicate = NSPredicate(format: "titre : %@",objet.titre as! CVarArg)
        fetchRequest.predicate = predicate
        
        do{
            
            let result: [Tache] = try managedContext.fetch(fetchRequest)
            
            for object in result {
                deleteTask(objet: object)
            }
            
            addTaskUpdated(titre: titre, description: description, myCreationDate: objet.dateCreation ?? Date())
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func addTask(titre: String , description: String) -> Tache{
        let managedContext = persistantContainer.viewContext
        let item = Tache(context: managedContext)
        item.titre = titre
        item.desc = description
        item.dateCreation = Date()
        item.dateMaj = Date()
        
        
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

