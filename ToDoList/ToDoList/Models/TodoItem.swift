//
//  TodoItem.swift
//  ToDoList
//
//  Created by Zhulien Zhekov on 13.08.25.
//

import Foundation

struct TodoItem: Identifiable, Equatable, Hashable, Codable {
    let id: UUID
    var title: String
    var isDone: Bool
    var note: String?

    init(id: UUID = UUID(), title: String, isDone: Bool = false, note: String? = nil) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.note = note
    }
}


