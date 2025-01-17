//
//  ContentView.swift
//  FirstApp
//
//  Created by Vlad Gabriel on 18.02.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var isPresentingPopup = false
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Items", systemImage: "plus")
                    }
                }
                ToolbarItem{
                    Button(action: popUp){
                        Label("Pop Up", systemImage: "rectangle.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $isPresentingPopup) {
                                VStack {
                                    Text("Hello")
                                        .font(.largeTitle)
                                        .padding()
                                    Button("Close") {
                                        isPresentingPopup = false
                                    }
                                    .padding()
                                }
                            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func popUp(){
        isPresentingPopup = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
