//
//  AddTaskView.swift
//  ToDoList
//
//  Created by Zhulien Zhekov on 13.08.25.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var note: String = ""
    var onAdd: (String, String?) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [
                    Color.blue.opacity(0.08),
                    Color.green.opacity(0.08)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("New Task")
                            .font(.title3.bold())

                        TextField("Title (e.g. Buy milk)", text: $title)
                            .textFieldStyle(.roundedBorder)
                            .submitLabel(.next)

                        TextField("Comment (optional)", text: $note, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3, reservesSpace: true)
                            .submitLabel(.done)
                            .onSubmit(save)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.background)
                            .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
                    )
                    .padding(.horizontal)

                    Button(action: save) {
                        Text("Add")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(canSave ? Color.accentColor : Color.gray.opacity(0.25))
                            .foregroundStyle(canSave ? .white : .secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .disabled(!canSave)
                    .padding(.horizontal)

                    Spacer(minLength: 0)
                }
                .padding(.top, 40)
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                    .padding()
                }
            }
        }
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func save() {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        let n = note.trimmingCharacters(in: .whitespacesAndNewlines)
        onAdd(t, n.isEmpty ? nil : n)
        dismiss()
    }
}

