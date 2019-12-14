//
//  CompletedTaskTableViewController.swift
//  ToDoAssistant
//
//  Created by Usama Sadiq on 12/9/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import RealmSwift

class CompletedTaskTableViewController: UITableViewController {
    
    
    let realm = try! Realm()
    
    var completedTasks: Results<CompletedTask>?
    
    @IBOutlet weak var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromRealm()
        
        print("detailView hidden property \(detailView.isHidden)")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return completedTasks?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let completed = completedTasks?[indexPath.row]{
            
            cell.textLabel!.text = "Cat[ \(completed.categoryTitle) ] -> Task{ \(completed.taskTitle)}"
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailView.isHidden = false
        loadDetails(of: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
//        tableView.cellForRow(at: indexPath)?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    //MARK: - Data Model Functions
    
    
    func loadDataFromRealm(){
        completedTasks = realm.objects(CompletedTask.self)
        tableView.reloadData()
    }
    
    //MARK: - Detail View
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDetail: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var dateCompltetion: UILabel!
    
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        detailView.isHidden = true
        
    }
    func loadDetails(of indexPath: IndexPath){
        
        if let task = completedTasks?[indexPath.row] {
            categoryTitle.text = task.categoryTitle
            taskTitle.text = task.taskTitle
            taskDetail.text = task.details
            dateCreated.text = getDateStirng(date: task.dateCreated)
            dateCompltetion.text = getDateStirng(date: task.dateCompleted)
        }
    }
    
    func getDateStirng(date: Date?) -> String
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
