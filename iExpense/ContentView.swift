//
//  ContentView.swift
//  iExpense
//
//  Created by Brendan Keane on 2021-04-19.
//

import SwiftUI

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
    
    var body: some View {
        NavigationView {
                VStack {
                    Button("Tap count: \(tapCount)") {
                        self.tapCount += 1
                        UserDefaults.standard.set(self.tapCount, forKey: "Tap")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
