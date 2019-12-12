//
//  CompletedTask.swift
//  ToDoAssistant
//
//  Created by Usama Sadiq on 12/9/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import Foundation
import RealmSwift

class CompletedTask: Object {
    @objc dynamic var categoryTitle: String = ""
    @objc dynamic var taskTitle: String = ""
    @objc dynamic var details: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated = Date()
    @objc dynamic var dateCompleted: Date?
    @objc dynamic var itemColor: String = ""
}
