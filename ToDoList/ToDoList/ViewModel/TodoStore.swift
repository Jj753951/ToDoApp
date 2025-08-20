//
//  TodoStore.swift
//  ToDoList
//
//  Created by Zhulien Zhekov on 13.08.25.
//

import Foundation

final class TodoStore: ObservableObject {
    @Published var items: [TodoItem] = [] {
        didSet { save() }
    }

    private let storageKey = "todos.storage.v1"

    init() {
        load()
    }

    func add(_ title: String, note: String? = nil) {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let n = note?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        items.append(TodoItem(title: t, note: (n?.isEmpty == true) ? nil : n))
    }

    func toggle(_ item: TodoItem) {
        guard let i = items.firstIndex(of: item) else { return }
        items[i].isDone.toggle()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }

    func updateTitle(_ item: TodoItem, to newTitle: String) {
        guard let i = items.firstIndex(of: item) else { return }
        let t = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        items[i].title = t
    }

    func updateNote(_ item: TodoItem, to newNote: String?) {
        guard let i = items.firstIndex(of: item) else { return }
        let n = newNote?.trimmingCharacters(in: .whitespacesAndNewlines)
        items[i].note = (n?.isEmpty == true) ? nil : n
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Save error:", error)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            items = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            print("Load error:", error)
        }
    }
}


