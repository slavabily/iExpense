//
//  ContentView.swift
//  iExpence
//
//  Created by slava bily on 18/3/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
    
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}

struct ContentView: View {
    @State private var showingAddExpense = false
    
    @ObservedObject var expences = Expenses()
 
    var body: some View {
        NavigationView {
            List {
                ForEach(expences.items) { (item) in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        if (0 ..< 10).contains(item.amount) {
                            Text("$\(item.amount)")
                            .font(.subheadline)
                        } else if (10 ..< 100).contains(item.amount) {
                            Text("$\(item.amount)")
                                .font(.headline)
                                .foregroundColor(.blue)
                        } else if item.amount >= 100 {
                            Text("$\(item.amount)")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                        }
                    }
                }
                .onDelete(perform: removeItems(at:))
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: {
                                    self.showingAddExpense = true
                                }, label: {
                                    Image(systemName: "plus")
                                }))
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expences)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expences.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
