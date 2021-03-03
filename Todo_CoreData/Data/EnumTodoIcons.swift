//
//  EnumTodoIcons.swift
//  Todo_CoreData
//
//  Created by lpiem2 on 24/02/2021.
//

import Foundation
import UIKit

enum EnumTodoIcons : String, CaseIterable, Codable {
    case Appointments
    case Birthdays
    case Chores
    case Drinks
    case Folder
    case Groceries
    case Inbox
    case NoIcon = "No Icon"
    case Photos
    case Trips
    var image : UIImage {
        return UIImage(named: self.rawValue)!
    }
}
