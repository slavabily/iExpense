//
//  AddView.swift
//  iExpence
//
//  Created by slava bily on 19/3/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @State private var showingBadValueAlert = false
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    @ObservedObject var expenses: Expenses
    
    @Environment(\.presentationMode) var presentationMode
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
//                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
        .navigationBarItems(trailing:
            Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    // problem with entered value description
                    self.showingBadValueAlert.toggle()
                }
                
        })
        }
        .alert(isPresented: $showingBadValueAlert) {
            Alert(title: Text("Wromg input!"), message: Text("Entered value is not a nuber. Please, enter the number."), dismissButton: .default(Text("Ok")))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
