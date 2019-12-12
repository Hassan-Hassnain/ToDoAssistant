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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromRealm()
        
        
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

    //MARK: - Data Model Functions
 
    
    func loadDataFromRealm(){
        completedTasks = realm.objects(CompletedTask.self)
        tableView.reloadData()
    }

}
