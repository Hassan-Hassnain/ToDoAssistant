//
//  TaskDetailsViewController.swift
//  ToDoAssistant
//
//  Created by Usama Sadiq on 12/8/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import RealmSwift

class TaskDetailsViewController: UIViewController {
    
    let realm = try! Realm()

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    var selectedTask: Task? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTaskDetails()
    }
    @IBAction func deleteButton(_ sender: UIButton) {
    
        if let taskForDeletion = selectedTask {
            do {
                try realm.write {
                    realm.delete(taskForDeletion)
                }
            } catch {
                print("Error while deleting the category from Realm \(error)")
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func doneButton(_ sender: UIButton) {
        do {
            try realm.write {
                selectedTask?.done = true
            }
        } catch {
            print("Error while deleting the category from Realm \(error)")
        }
    }
    
    
    func loadTaskDetails(){
        
        taskTitle.text = selectedTask?.title
        
        details.text = selectedTask?.details
        
        if let dc = selectedTask?.dateCreated {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            creationDate.text = formatter.string(from: dc)
        }
    }
    
}
