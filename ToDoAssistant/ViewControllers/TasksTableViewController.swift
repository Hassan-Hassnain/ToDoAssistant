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
    var totalTasks: Int?
    var segueTo: String?
    var selectedCategory: Category?{
        didSet{
            loadDataFromRealm()
        }
    }
    // Detail View Components
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    var selectedTask: Task? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60.0
        loadDataFromRealm()
        navigationItem.title = selectedCategory?.title
        //navigationItem.backBarButtonItem?.tintColor = UIColor.white
        //if let a = selectedCategory { print(a.title!)}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - New Category Add Button Function
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var taskTitle = UITextField()
        var taskDetails = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTitle) in
            alertTitle.placeholder = "Add the name of new task"
            taskTitle = alertTitle
        }
        alert.addTextField { (alertDetails) in
            alertDetails.placeholder = "Add Details of the Task"
            taskDetails = alertDetails
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let title = taskTitle.text {
                
                if let currenCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            
                            let newTask = Task()
                            newTask.title = title
                            if let details = taskDetails.text {  newTask.details = details   }
                            newTask.dateCreated = Date()
                            currenCategory.tasks.append(newTask)
                            if let total = self.totalTasks {currenCategory.numOfTasks = total}
                            
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
        totalTasks = tasks?.count
        return tasks?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for:  indexPath) as! SwipeTableViewCell
        //also set the custom Class in Identity inspector of resuseable cell
        cell.delegate = self
        
        if let task = tasks?[indexPath.row]{
            cell.textLabel?.text = task.title
            cell.accessoryType = task.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Task Created"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        segueTo = "detailView"
        //        performSegue(withIdentifier: "GoToTaskDetails", sender: self)
        selectedTask = tasks?[indexPath.row]
        detailView.isHidden = false
        showTaskDetail(Of: indexPath)
        
    }
    
    @IBAction func completedButtonPressed(_ sender: UIBarButtonItem) {
        segueTo = "completedView"
        performSegue(withIdentifier: "GoToCompleted", sender: self)
        
    }
    
    @IBAction func deletedButtonPressed(_ sender: UIBarButtonItem) {
        print("deleted")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segueTo == "detailView" {
            let destinationVC = segue.destination as! TaskDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedTask = tasks?[indexPath.row]
            }
        } else if segueTo == "completedView" {
            _ = segue.destination as! CompletedTaskTableViewController
        }
        
        
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
            
            saveToCompletedList(at: indexPath)
            
            
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
    
    func saveToCompletedList(at indexPath: IndexPath) {
        
        var compTask = CompletedTask()
        if let item = selectedCategory?.tasks[indexPath.row] {
            if let catTitle = selectedCategory?.title { compTask.categoryTitle = catTitle}
            compTask.taskTitle = (item.title)
            compTask.details = (item.details)
            compTask.dateCreated = item.dateCreated!
            compTask.dateCompleted = Date()
        }
        
        do {
            try realm.write {
                realm.add(compTask)
            }
        } catch {
            print("Error during saving data \(error)")
        }
    }
    //MARK: - Detail View
    
    
    
    @IBAction func deleteTaskButton(_ sender: UIButton) {
            if let taskForDeletion = selectedTask {
                do {
                    try realm.write {
                        realm.delete(taskForDeletion)
                    }
                } catch {
                    print("Error while deleting the category from Realm \(error)")
                }
            }
        
        loadDataFromRealm()
        detailView.isHidden = true
        
    }
    @IBAction func markAsCompleteTaskButton(_ sender: UIButton) {
        if let taskForCompletin = selectedTask {
            do {
                try realm.write {
                    taskForCompletin.done = true
                }
            } catch {
                print("Error while deleting the category from Realm \(error)")
            }
        }
        
        let task = CompletedTask()
        task.categoryTitle = (selectedCategory?.title!)!
        task.taskTitle = selectedTask!.title
        task.details = selectedTask!.details
        task.dateCreated = selectedTask!.dateCreated!
        task.dateCompleted = selectedTask!.dateCompleted
        loadDataFromRealm()
        detailView.isHidden = true
        
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            print("Error while deleting the category from Realm \(error)")
        }
        
        do {
            try realm.write {
                realm.delete(selectedTask!)
            }
        } catch {
            print("Error while deleting the category from Realm \(error)")
        }
        
        loadDataFromRealm()
        detailView.isHidden = true
    }
    
    func showTaskDetail(Of indexpath: IndexPath) {
        if let task = tasks?[indexpath.row] {
            titleLabel.text = task.title
            detailLabel.text = task.details
            createdDate.text = getDateStirn(date: task.dateCreated)
            completionDate.text = getDateStirn(date: task.dateCompleted)
        }
    }
    
    
    func getDateStirn(date: Date?) -> String
    {
        if date != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: date!)
        }
        else {
            return "--:--:----"
        }
        
    }
    
    
    
}




