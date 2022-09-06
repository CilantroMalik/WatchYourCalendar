//
//  WatchConfig.swift
//  whatever
//
//  Created by Rohan Malik on 8/29/22.
//

import SwiftUI

struct Override: Identifiable {
    let id = UUID()
    var block: String
    var day: Int
    var name: String
}

struct WatchConfig: View {
    @State var classesWC: [String] = ["", "", "", "", "", "", "", "", "", ""]
    @State var firstLunch: [Int] = [0, 0, 0, 0, 0, 0]
    @State var sportsPhone: [String] = ["", "", "", "", "", ""]
    @State var overrides = [Override]()
    @State var orName = ""
    @State var orBlock = "A"
    @State var orDay = 1
    @State var showingAlert = false
    
    func blockForm(_ bl: String, _ i: Int) -> some View {
        return HStack {
            Text("\(bl) Block:").padding(.leading, 15.0)
            TextField("Class", text: $classesWC[i], prompt: Text("Fill in class name here..."))
        }
    }
    
    func sportsForm(_ dayNum: Int) -> some View {
        return HStack {
            Text("Day \(dayNum):").padding(.leading, 15.0)
            TextField("Sports", text: $sportsPhone[dayNum-1], prompt: Text("Sport name..."))
        }
    }
    
    func sendToWatch() {
        let lunches = firstLunch
        let classArr = classesWC
        let sportsArr = sportsPhone
        for i in 0...5 {
            ZLunch[i+1] = lunches[i]
            sports[i] = sportsArr[i] == "" ? "Go Home!" : sportsArr[i]
        }
        let a = classArr[0]
        let b = classArr[1]
        let c = classArr[2]
        let d = classArr[3]
        let e = classArr[4]
        let f = classArr[5]
        let g = classArr[6]
        let h = classArr[7]
        let z = classArr[8]
        classes[1] = [a, b, c, z, d]
        classes[2] = [e, f, g, z, h]
        classes[3] = [d, a, b, z, c]
        classes[4] = [h, e, f, z, g]
        classes[5] = [c, d, a, z, b]
        classes[6] = [g, h, e, z, f]
        
        for or in overrides {
            classes[or.day]![blocks[or.day]!.firstIndex(of: or.block)!] = or.name
        }
        
        UserDefaults.standard.set(lunches, forKey: "ZLunch")
        UserDefaults.standard.set(classArr, forKey: "classes")
        UserDefaults.standard.set(sportsArr, forKey: "sports")
        
        Connectivity.shared.send(obj: ["classes": classesWC, "ZLunch": firstLunch,  "sports": sportsPhone, "eventsList": EventsListObs.evList])
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    Text("WatchYourCalendar Configuration").fontWeight(.bold).font(.system(size: 24))
                    Divider().padding(.vertical, 7).padding(.horizontal, 5)
                    Text("Please fill in your classes below.").padding(.bottom, 5)
                    Text("If you have a free during a block, type 'Free'.").multilineTextAlignment(.center).padding(.bottom, 10)
                    Group {
                        blockForm("A", 0)
                        blockForm("B", 1)
                        blockForm("C", 2)
                        blockForm("D", 3)
                        blockForm("E", 4)
                        blockForm("F", 5)
                        blockForm("G", 6)
                        blockForm("H", 7)
                        blockForm("Z", 8)
                    }
                    Divider().padding(.horizontal, 5)
                }
                Group {
                    Text("Add Overrides").fontWeight(.semibold).font(.system(size: 20))
                    Text("Use this space to add classes that occur in specific periods but not during all occurrences of the block (e.g. PE Fitness, Life Skills, OPI, Junior Seminar, etc).").multilineTextAlignment(.center).font(.system(size: 10)).padding(.horizontal)
                    if overrides.count != 0 {
                        Text("Current Overrides: ")
                        ForEach(overrides, id: \.id) { or in Text("Day \(or.day), \(or.block) Block: \(or.name)") }
                    }
                    HStack {
                        Text("Block: ")
                        Picker("Day", selection: $orBlock) {
                            ForEach(["A", "B", "C", "D", "E", "F", "G", "H", "Z"], id: \.self) { i in Text(i) }
                        }
                        Divider()
                        Text("Day: ")
                        Picker("Day", selection: $orDay) {
                            ForEach([1, 2, 3, 4, 5, 6], id: \.self) { i in Text(String(i)) }
                        }
                        Divider()
                        TextField("Class", text: $orName, prompt: Text("Class name"))
                    }
                    Button("Add", action: {
                        if (["A", "B", "C", "D"].contains(orBlock) && orDay % 2 == 0) || (["E", "F", "G", "H"].contains(orBlock) && orDay % 2 == 1) {
                            showingAlert = true
                        } else {
                            overrides.append(Override(block: orBlock, day: orDay, name: orName))
                            orBlock = "A"
                            orDay = 1
                            orName = ""
                        }
                    }).alert("Invalid day/block combination", isPresented: $showingAlert){}
                    Divider()
                }
                Text("For each day, pick either Z1, Z2, or both, depending on when you have lunch.").multilineTextAlignment(.center).padding(.bottom, 10).padding(.top, 15)
                HStack {
                    VStack {
                        HStack {
                            Text("Day 1: ")
                            Picker("Day 1", selection: $firstLunch[0]) { ForEach([3, 1, 2], id: \.self) { i in
                                Text(i == 3 ? "Both" : (i == 1 ? "Z1" : "Z2"))
                            } }
                        }
                        HStack {
                            Text("Day 2: ")
                            Picker("Day 2", selection: $firstLunch[1]) { ForEach([3, 1, 2], id: \.self) { i in
                                Text(i == 3 ? "Both" : (i == 1 ? "Z1" : "Z2"))
                            } }
                        }
                        HStack {
                            Text("Day 3: ")
                            Picker("Day 3", selection: $firstLunch[2]) { ForEach([3, 1, 2], id: \.self) { i in
                                Text(i == 3 ? "Both" : (i == 1 ? "Z1" : "Z2"))
                            } }
                        }
                    }.padding(.horizontal)
                    VStack {
                        HStack {
                            Text("Day 4: ")
                            Picker("Day 4", selection: $firstLunch[3]) { ForEach([3, 1, 2], id: \.self) { i in
                                Text(i == 3 ? "Both" : (i == 1 ? "Z1" : "Z2"))
                            } }
                        }
                        HStack {
                            Text("Day 5: ")
                            Picker("Day 5", selection: $firstLunch[4]) { ForEach([3, 1, 2], id: \.self) { i in
                                Text(i == 3 ? "Both" : (i == 1 ? "Z1" : "Z2"))
                            } }
                        }
                        HStack {
                            Text("Day 6: ")
                            Picker("Day 6", selection: $firstLunch[5]) { ForEach([3, 1, 2], id: \.self) { i in
                                Text(i == 3 ? "Both" : (i == 1 ? "Z1" : "Z2"))
                            } }
                        }
                    }.padding(.horizontal)
                }
                Divider().padding(.vertical, 10)
                Group {
                    Text("Fill in any after-school sports (PE or team) for each day, or leave blank if none.").multilineTextAlignment(.center).padding()
                    HStack {
                        VStack {
                            sportsForm(1)
                            sportsForm(2)
                            sportsForm(3)
                        }
                        VStack {
                            sportsForm(4)
                            sportsForm(5)
                            sportsForm(6)
                        }
                    }
                }
                Divider().padding(.horizontal, 10)
                Button("Update Info", action: {sendToWatch()})
            }
        }
    }
}

struct WatchConfig_Previews: PreviewProvider {
    static var previews: some View {
        WatchConfig()
    }
}
