//
//  AddView.swift
//  iExpense
//
//  Created by Brendan Keane on 2021-04-20.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    @ObservedObject var expenses: Expenses //does not create an expense object, but does let us know that one will exist
    // storing an instance of AddViews presentation mode, no type neede, as the @Environment allows swift ot figure it out
    @Environment(\.presentationMode) var presentationMode
    
    static let types = ["Buisness", "Personal"]
    
    @State private var alertVisable = false
    let errorTitle = "Error, invalid user selction"
    let errorMessage = "Please enter a valid numerical price"
    
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
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expenses")
            .navigationBarItems(trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    //we need this wrapped value to actuall dig inside the presentation mode
                    self.presentationMode.wrappedValue.dismiss()//this will toggle showingAddExpense in the Content View, dismissing AddView
                } else {
                    alertVisable.toggle()
                }
            })
            .alert(isPresented: $alertVisable) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Try Again?")))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
