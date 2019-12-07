//
//  TasksTableViewController.swift
//  ToDoAssistant
//
//  Created by Usama Sadiq on 12/8/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TasksTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let realm = try! Realm()
    var tasks: Results<Task>?
    var selectedCategory: Category?{
        didSet{
            loadDataFromRealm()
        }
    }
    
      override func viewDidLoad() {
          super.viewDidLoad()
          tableView.rowHeight = 60.0
          loadDataFromRealm()
          
      }
      
      //MARK: - New Category Add Button Function
      
    @IBAction func addButton(_ sender: UIBarButtonItem) {
          var textField = UITextField()

          let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
          
          alert.addTextField { (alertTextField) in
              alertTextField.placeholder = "Add the name of new Category"
              textField = alertTextField
          }

          let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
              if let text = textField.text {
                  
                if let currentTask = self.selectedCategory {
                    do {
                        try self.realm.write {
                            
                            let newTask = Task()
                            newTask.title = text
                            currentTask.tasks.append(newTask)
                        }
                    } catch {
                        print("Error saving new Task to realm \(error)")
                    }
                }
                self.tableView.reloadData()
              }
          }

          alert.addAction(action)
          present(alert, animated: true, completion: nil)
      }
      
      //MARK: - Table View Functions
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return tasks?.count ?? 1
      }
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for:  indexPath) as! SwipeTableViewCell
          //also set the custom Class in Identity inspector of resuseable cell
          cell.delegate = self
          
          if let task = tasks?[indexPath.row]{
              cell.textLabel?.text = task.title
          } else {
            cell.textLabel?.text = "No Task Created"
        }
          
          return cell
      }
      //MARK: - SwipeTableView Delegate Function
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

      func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
          var options = SwipeOptions()
          options.expansionStyle = .destructive
          return options
      }

      //MARK: - Data Model Functions
      
//      func saveToRealm(This task: Task) {
//          do {
//              try realm.write {
//                  realm.add(task)
//              }
//          } catch {
//              print("Error during saving data \(error)")
//          }
//          loadDataFromRealm()
//      }
      
     func loadDataFromRealm(){
          tasks = selectedCategory?.tasks.sorted(byKeyPath:  "title", ascending: true)
          tableView.reloadData()
      }
    
      func updateModel(at indexPath: IndexPath){
          if let catForDeletion = tasks?[indexPath.row] {
              do {
                  try realm.write {
                      realm.delete(catForDeletion)
                  }
              } catch {
                  print("Error while deleting the category from Realm \(error)")
              }
          }
          tableView.reloadData()
      }
}
