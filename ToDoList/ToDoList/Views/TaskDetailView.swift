//
//  TaskDetailView.swift
//  ToDoList
//
//  Created by Zhulien Zhekov on 13.08.25.
//

import SwiftUI

struct TaskDetailView: View {
    let item: TodoItem
    @ObservedObject var store: TodoStore

    @State private var title: String
    @State private var note: String

    init(item: TodoItem, store: TodoStore) {
        self.item = item
        self.store = store
        _title = State(initialValue: item.title)
        _note  = State(initialValue: item.note ?? "")
    }

    var body: some View {
        Form {
            Section(header: Text("Task")) {
                TextField("Title", text: $title)
                    .onSubmit(saveTitle)
                Toggle("Done", isOn: Binding(
                    get: { itemBinding?.isDone ?? false },
                    set: { newVal in
                        guard let item = itemBinding else { return }
                        var tmp = item
                        tmp.isDone = newVal
                        store.toggle(item)
                    }
                ))
            }

            Section(header: Text("Comment")) {
                TextEditor(text: $note)
                    .frame(minHeight: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }

            Section {
                Button("Save Changes") { saveAll() }
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: saveAll)
    }

    private var itemBinding: TodoItem? {
        store.items.first(where: { $0.id == item.id })
    }

    private func saveTitle() {
        store.updateTitle(item, to: title)
    }

    private func saveAll() {
        store.updateTitle(item, to: title)
        store.updateNote(item, to: note)
    }
}


