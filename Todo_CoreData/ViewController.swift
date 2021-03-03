//
//  ViewController.swift
//  Todo_CoreData
//
//  Created by lpiem2 on 24/02/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let myManager:DataManagerProtocol = DataManager.shared
        
        myManager.addTask(titre: "tache test", description: "description test")
        myManager.addCategory(titre: "categorie test")
        
    }


}


