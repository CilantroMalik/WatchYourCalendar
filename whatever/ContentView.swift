//
//  ContentView.swift
//  WatchYourCalendar
//
//  Created by us on 4/20/22.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @State var classes: [String] = ["", "", "", "", "", "", "", ""]
    @State var firstLunch: [Bool] = [false, false, false, false, false, false, false, false]
    
    func blockForm(_ bl: String) -> some View {
        return HStack {
            Text("\(bl) Block:").padding(.leading, 15.0)
            TextField("Class", text: $classes[0], prompt: Text("Fill in class name here"))
        }
    }
    
    func sendToWatch() {
        Connectivity.shared.send(obj: ["classes": classes, "firstLunch": firstLunch])
    }
    
    var body: some View {
        VStack {
            Text("WatchYourCalendar Configuration").fontWeight(.bold).font(.system(size: 20))
            Divider().padding(.vertical, 7).padding(.horizontal, 5)
            Text("Please fill in your classes below.").padding(.bottom, 5)
            Text("If you have a free during a block, type 'Free'.").multilineTextAlignment(.center).padding(.bottom, 10)
            Group {
                blockForm("A")
                blockForm("B")
                blockForm("C")
                blockForm("D")
                blockForm("E")
                blockForm("F")
                blockForm("G")
                blockForm("H")
            }
            Divider().padding(.horizontal, 5)
            Text("Check each day that you have first lunch.").multilineTextAlignment(.center).padding(.bottom, 10).padding(.top, 15)
            HStack {
                VStack {
                    Toggle(isOn: $firstLunch[0]) { Text("Day 1") }.padding(.horizontal, 35.0).toggleStyle(.switch)
                    Toggle(isOn: $firstLunch[0]) { Text("Day 2") }.padding(.horizontal, 35.0).toggleStyle(.switch)
                    Toggle(isOn: $firstLunch[0]) { Text("Day 3") }.padding(.horizontal, 35.0).toggleStyle(.switch)
                    Toggle(isOn: $firstLunch[0]) { Text("Day 4") }.padding(.horizontal, 35.0).toggleStyle(.switch)
                }
                VStack {
                    Toggle(isOn: $firstLunch[0]) { Text("Day 5") }.padding(.horizontal, 35.0).toggleStyle(.switch)
                    Toggle(isOn: $firstLunch[0]) { Text("Day 6") }.padding(.horizontal, 35.0).toggleStyle(.switch)
                    Toggle(isOn: $firstLunch[0]) { Text("Day 7") }.padding(.horizontal, 35.0).toggleStyle(.switch)
                    Toggle(isOn: $firstLunch[0]) { Text("Day 8") }.padding(.horizontal, 35.0).toggleStyle(.switch)
                }
            }
            Divider().padding(.vertical, 10)
            Button("Send to Watch App", action: {sendToWatch()})
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
