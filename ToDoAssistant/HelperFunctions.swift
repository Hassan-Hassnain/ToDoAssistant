//
//  HelperFunctions.swift
//  ToDoAssistant
//
//  Created by Usama Sadiq on 12/13/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import Foundation
import RealmSwift
import SwipeCellKit

class HelperFunctions: UITableViewController, SwipeTableViewCellDelegate{
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        
    }
//MARK: - SWIPE TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete")
        { action, indexPath in
            // handle action by updating model with deletion

           self.updateModel(at: indexPath)

        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete-Icon")
        //tableView.reloadData()
        return [deleteAction]
    }
//MARK: - Data Model Functions
   
    
    func updateModel(at indexPath: IndexPath)
    {
        //func is overriden
    }
    
}
