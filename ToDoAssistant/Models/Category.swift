//
//  Category.swift
//  ToDoAssistant
//
//  Created by Usama Sadiq on 12/7/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var title: String?
    @objc dynamic var numOfTasks: Int = 0
    let tasks = List<Task>()
}
