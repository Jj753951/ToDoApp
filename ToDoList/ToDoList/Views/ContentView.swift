//
//  ContentView.swift
//  ToDoList
//
//  Created by Zhulien Zhekov on 12.08.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = TodoStore()
    @State private var showingAdd = false

    private var bg: some View {
        LinearGradient(colors: [.blue.opacity(0.10), .green.opacity(0.10)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("To-Do")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) { EditButton() }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { showingAdd = true } label: {
                            Image(systemName: "plus.circle.fill").font(.title2)
                        }
                    }
                }
                .sheet(isPresented: $showingAdd) {
                    AddTaskView { title, note in
                        withAnimation(.snappy) { store.add(title, note: note) }
                    }
                    .presentationDetents([.height(260)])
                    .presentationCornerRadius(20)
                }
                .animation(.snappy, value: store.items)
        }
        .background(bg)
    }

    @ViewBuilder private var content: some View {
        if store.items.isEmpty {
            EmptyState()
        } else {
            List {
                ForEach(store.items) { item in
                    NavigationLink {
                        TaskDetailView(item: item, store: store)
                    } label: {
                        TaskRow(title: item.title, isDone: item.isDone) {
                            withAnimation(.snappy) { store.toggle(item) }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 2)
                }
                .onDelete(perform: store.delete)
                .onMove(perform: store.move)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

private struct EmptyState: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checklist")
                .font(.system(size: 56, weight: .bold))
                .foregroundStyle(.secondary)
            Text("No tasks yet").font(.title3.bold())
            Text("Tap the + to add your first task.").foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct TaskRow: View {
    let title: String
    let isDone: Bool
    var onToggle: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: onToggle) {
                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(isDone ? .green : .secondary)
                    .padding(6)
                    .background(Circle().fill(isDone ? Color.green.opacity(0.18) : Color.gray.opacity(0.12)))
            }
            .buttonStyle(.plain)

            Text(title)
                .lineLimit(2)
                .strikethrough(isDone, pattern: .solid, color: .secondary)
                .foregroundStyle(isDone ? .secondary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.background.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.gray.opacity(0.15))
                )
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
        .contentShape(Rectangle())
        .animation(.snappy, value: isDone)
    }
}


#Preview {
  TaskRow(title: "Buy milk", isDone: false) { }
}
