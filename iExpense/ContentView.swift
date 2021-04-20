//
//  ContentView.swift
//  iExpense
//
//  Created by Brendan Keane on 2021-04-19.
//

import SwiftUI

// class to store our array of expense types
class Expenses: ObservableObject{
    @Published var items = [ExpenseItem]() {
        // check for changes in items
        didSet {
            // creat a Json encoder
            let encoder = JSONEncoder()
            // try to encode our class array into JSON style
            if let encoded = try? encoder.encode(items) {
                //store our data into the user defaults under our chosen key term
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    //initialises app with initial settings (stored by user)
    init() {
        //check to see if there is any data stored with our key word
        if let items = UserDefaults.standard.data(forKey: "Items") {
            //create a JSON decoder
            let decoder = JSONDecoder()
            // try to decode our data into an array of ExpenseItem types
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                //store resulting data into out class
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    
    @State private var showingAddExpense = false //determine if AddExpense view is showing
    var body: some View {
        NavigationView {
            List {
                // because ExpenseItem is an identifiable property, we don't need ,id: \.id - it is now assumed
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                            .foregroundColor((item.amount<=10) ? Color.green : ((item.amount>=100) ? Color.red : Color.black))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            //.navigationBarItems(leading: EditButton())
            .navigationBarItems(leading: EditButton()
                                , trailing: Button(action: {
                                        self.showingAddExpense = true
                                    }) {
                                        Image(systemName: "plus")
                                    }
            )
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: self.expenses)
            }
        }
    }
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

// this is all example code for learning purposes
/*
struct SecondView: View {
    var name: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button("Dismiss") {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
struct User: Codable {
    var firstName: String
    var lastName: String
}

struct ContentView: View {
    @State private var showingSheet  = false
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    
    @State private var user = User(firstName: "Taylor", lastName: "Swift")
    
    var body: some View {
        NavigationView {
                VStack {
                    Button("Tap count: \(tapCount)") {
                        //self.tapCount += 1
                        let encoder = JSONEncoder()
                        
                        if let data = try? encoder.encode(self.user) {
                            UserDefaults.standard.set(data, forKey: "UserData")
                        }
                        //UserDefaults.standard.set(self.tapCount, forKey: "Tap")
                    }
                    List {
                        ForEach(numbers, id: \.self) {
                            Text("\($0)")
                        }
                        .onDelete(perform: removeRows)
                    }
                    Button("Add Number") {
                        self.numbers.append(self.currentNumber)
                        self.currentNumber += 1
                    }
                    Button("Show Sheet") {
                        self.showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                        SecondView(name: "@bkeane")
                    }
                }
                .navigationBarItems(leading: EditButton())
            }
        }
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}
*/
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
